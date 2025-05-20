// Copyright 2025 Mehmet CANEVİ
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
#include "hardware_info.h"

#include <iostream>
#include <memory>
#include <stdexcept>
#include <string>
#include <array>
#include <ranges>
#include <algorithm>
#include <cctype>

// NTP internet time related
#include <winsock2.h>
#include <ws2tcpip.h>
#include <cstdint>
#include <iomanip>
#include <sstream>
#pragma comment(lib, "ws2_32.lib")
// NTP timestamp starts in 1900, Unix in 1970, difference in seconds
#define NTP_TIMESTAMP_DELTA 2208988800ull
#define NTP_PACKET_SIZE 48


std::string run_command(const char* cmd) {
    std::array<char, 128> buffer;
    std::string result;

    // Open pipe to file
    FILE* pipe = _popen(cmd, "r");
    if (!pipe) {
        throw std::runtime_error("popen() failed!");
    }

    // read till end of process:
    while (fgets(buffer.data(), static_cast<int>(buffer.size()), pipe) != nullptr) {
        result += buffer.data();
    }

    // close pipe and return result
    _pclose(pipe);
    return result;
}

// Trim baştan ve sondan boşluk silme
static inline std::string trim(const std::string& s) {
    auto start = s.begin();
    while (start != s.end() && std::isspace(*start)) start++;
    auto end = s.end();
    do {
        end--;
    } while (std::distance(start, end) > 0 && std::isspace(*end));
    return std::string(start, end + 1);
}

// extract_single_line örneği (ilk satırı al, "başlık" kelimesinden sonrası)
std::string extract_single_line(const std::string& text, const std::string& header) {
    auto pos = text.find(header);
    if (pos == std::string::npos) return "";
    auto line = text.substr(pos + header.length());
    return trim(line);
}

std::string get_cpu_id() {
    return extract_single_line(run_command("wmic cpu get processorid"), "ProcessorId");
}

std::string get_bios_serial() {
    std::string s = extract_single_line(run_command("wmic bios get serialnumber"), "SerialNumber");
    
    // trim sonucu kesin temizle
    s.erase(std::remove_if(s.begin(), s.end(),
    [](unsigned char c) { return c==' ' || c == ',' || c=='\r' || c=='\n'; }),
    s.end());
    
    // tüm karakterleri küçült
    std::transform(s.begin(), s.end(), s.begin(),
        [](unsigned char c) -> char { return static_cast<char>(std::tolower(c)); });

    if (!s.empty()
        && s != "defaultstring"
        && s != "tobefilledbyo.e.m."
        && s != "unknown"
        && s != "none"
        && s != "null"
        && s != "0000000000000000") {
        return s;
    }

    return "Unknown";
}

std::string get_motherboard_uuid() {
    std::string s = extract_single_line(run_command("wmic csproduct get uuid"), "UUID");
    
    // // trim sonucu kesin temizle
    // s.erase(std::remove_if(s.begin(), s.end(),
    // [](unsigned char c) { return c==' ' || c == ',' || c=='\r' || c=='\n'; }),
    // s.end());
    
    // // tüm karakterleri küçült
    // std::transform(s.begin(), s.end(), s.begin(),
    //     [](unsigned char c) -> char { return static_cast<char>(std::tolower(c)); });

    return s;
    // if (!s.empty()
    //     && s != "defaultstring"
    //     && s != "default string,"
    //     && s != "tobefilledbyo.e.m."
    //     && s != "unknown"
    //     && s != "none"
    //     && s != "null"
    //     && s != "0000000000000000") {
    //     return s;
    // }

    // return "Unknown";
}


time_t get_ntp_time_with_timeout(const char* server = "time.windows.com") {
    WSADATA wsaData;
    if (WSAStartup(MAKEWORD(2, 2), &wsaData) != 0) {
        std::cerr << "WSAStartup failed\n";
        return 0;
    }

    SOCKET sockfd = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
    if (sockfd == INVALID_SOCKET) {
        std::cerr << "socket creation failed\n";
        WSACleanup();
        return 0;
    }

    // Set receive timeout to 3 seconds
    int timeout_ms = 3000;
    setsockopt(sockfd, SOL_SOCKET, SO_RCVTIMEO, (const char*)&timeout_ms, sizeof(timeout_ms));

    sockaddr_in server_addr{};
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(123);  // NTP port

    // Resolve DNS for NTP server
    addrinfo hints{}, *res = nullptr;
    hints.ai_family = AF_INET;
    hints.ai_socktype = SOCK_DGRAM;
    if (getaddrinfo(server, "123", &hints, &res) != 0 || !res) {
        std::cerr << "DNS resolution failed\n";
        closesocket(sockfd);
        WSACleanup();
        return 0;
    }
    server_addr = *(sockaddr_in*)res->ai_addr;
    freeaddrinfo(res);

    // Prepare NTP request packet
    unsigned char packet[NTP_PACKET_SIZE] = {0};
    packet[0] = 0x1B;  // LI=0, VN=3, Mode=3 (client)

    if (sendto(sockfd, (char*)packet, NTP_PACKET_SIZE, 0, (sockaddr*)&server_addr, sizeof(server_addr)) == SOCKET_ERROR) {
        std::cerr << "sendto failed\n";
        closesocket(sockfd);
        WSACleanup();
        return 0;
    }

    sockaddr_in from_addr{};
    int from_len = sizeof(from_addr);

    int recv_len = recvfrom(sockfd, (char*)packet, NTP_PACKET_SIZE, 0, (sockaddr*)&from_addr, &from_len);
    if (recv_len == SOCKET_ERROR) {
        int err = WSAGetLastError();
        if (err == WSAETIMEDOUT) {
            std::cerr << "recvfrom timed out (no response)\n";
        } else {
            std::cerr << "recvfrom failed with error: " << err << "\n";
        }
        closesocket(sockfd);
        WSACleanup();
        return 0;
    }

    closesocket(sockfd);
    WSACleanup();

    // Extract transmit timestamp (bytes 40 to 43)
    unsigned long long int secs_since_1900 = 0;
    for (int i = 40; i < 44; ++i) {
        secs_since_1900 = (secs_since_1900 << 8) | packet[i];
    }

    if (secs_since_1900 == 0) {
        return 0; // invalid response
    }

    // Convert to UNIX time (seconds since 1970)
    time_t unix_time = (time_t)(secs_since_1900 - NTP_TIMESTAMP_DELTA);

    return unix_time;
}

std::string get_ntp_date()
{
    time_t t = get_ntp_time_with_timeout();
    if (t == 0) {
        return "Failed to get time from NTP server";
    } else {
        struct tm timeinfo;
        // Use gmtime_s (thread-safe) to get UTC time broken down
        if (gmtime_s(&timeinfo, &t) != 0) {
            return "Failed to convert time";
        }
        std::ostringstream oss;
        oss << std::put_time(&timeinfo, "%Y-%m-%dT%H:%M:%SZ");
        return oss.str();
    }
}
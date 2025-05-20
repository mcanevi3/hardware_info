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
    return extract_single_line(run_command("wmic bios get serialnumber"), "SerialNumber");
}

std::string get_motherboard_uuid() {
    return extract_single_line(run_command("wmic csproduct get uuid"), "UUID");
}

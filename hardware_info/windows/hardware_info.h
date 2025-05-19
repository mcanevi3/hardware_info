#ifndef HARDWARE_INFO_H
#define HARDWARE_INFO_H
#include <string>

std::string get_cpu_id();
std::string get_bios_serial();
std::string get_motherboard_uuid();

std::string get_ntp_date();
#endif
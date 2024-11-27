#pragma once 

#include <spdlog/spdlog.h>
#include <spdlog/sinks/basic_file_sink.h>

extern std::shared_ptr<spdlog::logger> glogger;

void log_info(const std::string& message);
void log_error(const std::string& message);
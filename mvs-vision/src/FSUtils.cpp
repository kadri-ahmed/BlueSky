#include "FSUtils.h"

std::shared_ptr<spdlog::logger> glogger;

void log_info(const std::string& message){
    glogger->info(message);
    spdlog::info(message);
}

void log_error(const std::string& message){
    glogger->error(message);
    spdlog::error(message);
}
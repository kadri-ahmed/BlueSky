
// Standard Library Imports
#include <iostream>
#include <string>
#include <filesystem>

// OpenCV Imports
#include <opencv2/calib3d/calib3d.hpp>
#include <opencv2/core.hpp>
#include <opencv2/highgui.hpp>

// External Libraries Imports
#include <yaml-cpp/yaml.h>
#include <Eigen/Dense>

// Files
#include "FSUtils.h"

int main(int argc, char* argv[]){

    /////////////////////////////////////////////////////////////////////////////////////////////
    ///// STEP 0: Initializations
    /////////////////////////////////////////////////////////////////////////////////////////////
    const cv::String keys = "{help h usage ? |              | print this message   }"
                            "{calib          |     ./       | path to calib.yaml file }" 
                            "{path           |     ./       | path to config.yaml file }"; 
    cv::CommandLineParser parser(argc, argv, keys);
    try{
        glogger = spdlog::basic_logger_mt("basic_logger", "/Users/ahmedkadri/Documents/Neural3d/github-repo/FrameSync/logs/framesync_logs.txt");
    }
    catch (const spdlog::spdlog_ex& e){
        std::cerr << "Log initialization failed: " << e.what() << std::endl;
        return EXIT_FAILURE;
    }

    if(!glogger){
        std::cout << "no logger" << std::endl;
        return 1;
    }


    if(parser.has("help")){
        parser.printMessage();
        return EXIT_SUCCESS;
    }

    std::string yaml_path{parser.get<std::string>("path")};
    YAML::Node config; 
    try
    {
        if(!std::filesystem::exists(yaml_path)){
            log_error(fmt::format("Couldn't find config file at path <{}>.", yaml_path));
            return EXIT_FAILURE;
        }
        config = YAML::LoadFile(yaml_path);
        log_info("Loaded config file successfully");

    }
    catch (YAML::Exception &e)
    {
        std::cerr << "Error: " << e.what() << std::endl;
        log_error(fmt::format("Couldn't read config file at path <{}>.", yaml_path));
        return EXIT_FAILURE;
    }
    catch (...){
        std::cerr << "Unknown error has occured" << std::endl;
        log_error(fmt::format("Unknown error has occurred reading config file at path <{}>.", yaml_path));
        return EXIT_FAILURE;
    }

    bool calibrationFileAvailable = config["calib_file_available"].as<bool>();
    
    return EXIT_SUCCESS;
}
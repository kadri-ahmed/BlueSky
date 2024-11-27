#include "FSImage.h"

// Standard Library Imports
#include <filesystem>
#include <utility>
#include <iostream>

// OpenCV Imports
#include <opencv2/imgcodecs.hpp>

// External Libraries Imports
#include <yaml-cpp/yaml.h>

// Files 

namespace FS = FrameSync;

FS::Image::Image(const std::string &filepath){
    if(!std::filesystem::exists(filepath)){
        log_error(fmt::format("Couldn't find image at path {}.", filepath));
    }
    this->m_data = cv::imread(filepath, cv::IMREAD_UNCHANGED);
    log_info(fmt::format("Successfully loaded image at path {}.", filepath));
}

FS::Image::Image(const Image& other){
    this->m_data = other.m_data;
}

FS::ImagePair::ImagePair(const std::string& leftImagePath, const std::string& rightImagePath, const std::string& calibFilePath){
    YAML::Node calibration; 
    try
    {
        if(!std::filesystem::exists(calibFilePath)){
            log_error(fmt::format("Couldn't find config file at path <{}>.", calibFilePath));
            throw std::runtime_error(fmt::format("Couldn't find config file at path <{}>.", calibFilePath));
        }
        calibration = YAML::LoadFile(calibFilePath);
        log_info("Loaded config file successfully");
    }
    catch (YAML::Exception &e)
    {
        std::cerr << "Error: " << e.what() << std::endl;
        log_error(fmt::format("Couldn't read config file at path <{}>.", calibFilePath));
        throw std::runtime_error(fmt::format("Couldn't read config file at path <{}>.", calibFilePath));
    }
    catch (...){
        std::cerr << "Unknown error has occured" << std::endl;
        log_error(fmt::format("Unknown error has occurred reading config file at path <{}>.", calibFilePath));
        throw std::runtime_error(fmt::format("Unknown error has occurred reading config file at path <{}>.", calibFilePath));
    }

    // Load intrinsics 
    std::vector<float> K0vec,K1vec;
    for(std::size_t i{0}, j{0}; i < calibration["K_00"].size(); ++i){
        K0vec.push_back(calibration["K_00"][i].as<float>());
        K1vec.push_back(calibration["K_01"].as<float>());
    }
    // cv::Mat Kl {Klvec}, Kr{Krvec};
    this->m_K = std::make_pair(cv::Mat{K0vec}, cv::Mat{K1vec});

    // load distortion coeffs
    std::vector<float> D0vec,D1vec;
    for(std::size_t i{0}, j{0}; i < calibration["D_00"].size(); ++i){
        D0vec.push_back(calibration["D_00"][i].as<float>());
        D1vec.push_back(calibration["D_01"].as<float>());
    }

    this->m_D = std::make_pair(cv::Mat{D0vec}, cv::Mat{D1vec});

    this->m_imagePair = std::make_pair(FS::Image(leftImagePath), FS::Image(rightImagePath));
}


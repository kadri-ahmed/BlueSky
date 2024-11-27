#pragma once 

// Standard Library Imports
#include <filesystem>

// OpenCV Imports
#include <opencv2/core.hpp>
#include <opencv2/imgcodecs.hpp>

// External Libraries Imports
#include <spdlog/spdlog.h>
#include <spdlog/sinks/basic_file_sink.h>

// Files 
#include "FSUtils.h"

namespace FrameSync{

    class Image{
    public:
        Image(const std::string &filepath);
        Image(const Image& other);
        Image() = default;

    private:
        cv::Mat m_data;
    };

    class ImagePair {
    public:

        ImagePair(const std::string& leftImagePath, const std::string& rightImagePath, const std::string& calibFilePath);

        const std::pair<cv::Mat, cv::Mat>& getIntrinsicsMat(){
            return this->m_K;
        }

        const std::pair<cv::Mat, cv::Mat>& getDistortionCoeffs(){
            return this->m_D;
        }

        const std::pair<cv::Mat, cv::Mat>& getRelativeCamTransformation(){
            return this->m_RT;
        }

    private:

        std::pair<Image, Image> m_imagePair;
        std::pair<cv::Mat, cv::Mat> m_K; // intrinsics matrix
        std::pair<cv::Mat, cv::Mat> m_D; // distortion coeffs;
        std::pair<cv::Mat, cv::Mat> m_RT; // relative camera transformation



    };
}
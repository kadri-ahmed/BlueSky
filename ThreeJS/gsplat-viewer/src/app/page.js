'use client';

import Image from "next/image";
import { textEmbeddingGenerator, cosineSimilarity, SCANNET_TEXT_LABELS } from "./models/clip";
import { useEffect, useState } from "react";



export default function Home() {
  const [noteText, setNoteText] = useState("");
  const [isLoading, setIsLoading] = useState(false);
  const [labelEmbeddings, setLabelEmbeddings] = useState(null);

  useEffect(() => {
    const calculateLabelEmbeddings = async () => {
      try {
        const embeddings = {}; // Store embeddings for each label
        // Calculate embeddings for each label
        for (const [key, label] of Object.entries(SCANNET_TEXT_LABELS)) {
          const embedding = await textEmbeddingGenerator(label);
          embeddings[key] = embedding;
        }
        setLabelEmbeddings(embeddings);
        console.log(
          "Label embeddings calculated for",
          Object.keys(embeddings).length,
          "classes"
        );
      } catch (error) {
        console.error("Error calculating label embeddings:", error);
      }
    };

    calculateLabelEmbeddings();

    const main = async () => {
      try {
        const canvas = document.getElementById("canvas");
        if (!canvas) return;

        const viewerModule = await import("./gsplat/main.js");
        // await viewerModule.default();
      } catch (err) {
        console.error(err);
        const message = document.getElementById("message");
        if (message) message.innerText = err.toString();
        const spinner = document.getElementById("spinner");
        if (spinner) spinner.style.display = "none";
      }
    };

    main();
  }, []);

  // Handler for query
  const handleQuery = async () => {
    if (!noteText) {
      alert("Please enter a description of the object you want to query");
      return;
    }
    
    setIsLoading(true);
    
    try {
      if(labelEmbeddings === null) {
        alert("Label embeddings not loaded. Please wait for the model to load.");
        return;
      }

      const queryEmbedding = await textEmbeddingGenerator(noteText);
      let closestLabel = null;
      let highestSimilarity = -Infinity;
      let furthestLabel = null;
      let lowestSimilarity = Infinity;

      // Calculate similarity scores for each semantic class
      const similarityScores = {};      

      for (const [label, embedding] of Object.entries(labelEmbeddings)) {
        const similarity = cosineSimilarity(queryEmbedding, embedding);
        similarityScores[label] = similarity;

        if (similarity > highestSimilarity) {
          highestSimilarity = similarity;
          closestLabel = SCANNET_TEXT_LABELS[label];
        }
        if (similarity < lowestSimilarity) {
          lowestSimilarity = similarity;
          furthestLabel = SCANNET_TEXT_LABELS[label];
        }
      } 

      // Trigger the canvas event handler
      if (window.handleQueryResults) {
        window.handleQueryResults(similarityScores);
      }
      
      console.log('Closest matching label:', closestLabel);
      console.log("Highest similarity:", highestSimilarity);
      console.log("Lowest similarity:", lowestSimilarity);
      console.log("Furthest matching label:", furthestLabel);

    } catch (error) {
      console.error("Error processing query:", error);
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="relative w-full h-screen bg-black text-white font-sans overflow-hidden">
      {/* Main canvas - lowest z-index */}
      <canvas
        id="canvas"
        className="block absolute top-0 left-0 w-full h-full z-0"
        style={{ touchAction: "none" }}
      />
      <canvas
        id="axes-canvas"
        className="absolute bottom-0 right-0 w-1/4 h-1/4 z-0 pointer-events-none"
      />

      {/* Info section - higher z-index */}
      <div
        id="info"
        className="absolute mt-5 ml-5 z-[100] bg-black/80 p-6 rounded-lg"
      >
        <h3 className="m-[5px_0]">Feature GSLAM Demo </h3>
        <p className="text-sm m-[5px_0]">
          <small>
            Viewer built on work of{" "}
            <a href="https://twitter.com/antimatter15" className="text-white">
              Kevin Kwok
            </a>
            . Code on{" "}
            <a
              href="https://github.com/antimatter15/splat"
              className="text-white"
            >
              Github
            </a>
            .
          </small>
        </p>

        <details>
          <summary className="text-sm cursor-pointer hover:text-gray-300">
            Use mouse or arrow keys to navigate.
          </summary>
          <div
            id="instructions"
            className="whitespace-pre-wrap rounded-[10px] text-xs mt-2"
          >
            {`movement (arrow keys)
              - left/right arrow keys to strafe side to side
              - up/down arrow keys to move forward/back
              - space to jump

              camera angle (wasd)
              - a/d to turn camera left/right
              - w/s to tilt camera up/down
              - q/e to roll camera counterclockwise/clockwise
              - i/k and j/l to orbit

              trackpad
              - scroll up/down/left/right to orbit
              - pinch to move forward/back
              - ctrl key + scroll to move forward/back
              - shift + scroll to move up/down or strafe

              mouse
              - click and drag to orbit
              - right click (or ctrl/cmd key) and drag up/down to move

              touch (mobile)
              - one finger to orbit
              - two finger pinch to move forward/back
              - two finger rotate to rotate camera clockwise/counterclockwise
              - two finger pan to move side-to-side and up-down

              gamepad
              - if you have a game controller connected it should work

              other
              - press 0-9 to switch to one of the pre-loaded camera views
              - press '-' or '+'key to cycle loaded cameras
              - press p to resume default animation
              - drag and drop .ply file to convert to .splat
              - drag and drop cameras.json to load cameras`}
          </div>
        </details>
      </div>

      {/* Progress bar */}
      <div
        id="progress"
        className="absolute top-0 h-[5px] bg-blue-600 z-[100] transition-[width] duration-100 ease-in-out"
      />

      {/* Message display */}
      <div
        id="message"
        className="absolute inset-0 flex items-center justify-center z-[100] text-red-500 font-bold text-lg pointer-events-none"
      />

      {/* Loading spinner */}
      <div
        id="spinner"
        className="absolute inset-0 flex items-center justify-center z-[100]"
      >
        <div className="cube-wrapper">
          <div className="cube">
            <div className="cube-faces">
              <div className="cube-face bottom" />
              <div className="cube-face top" />
              <div className="cube-face left" />
              <div className="cube-face right" />
              <div className="cube-face back" />
              <div className="cube-face front" />
            </div>
          </div>
        </div>
      </div>

      {/* Quality/FPS counter */}
      <div id="quality" className="absolute bottom-10 right-10 z-[100]">
        <span id="fps" />
      </div>

      {/* Camera info */}
      <div id="caminfo" className="absolute top-10 right-10 z-[100]">
        <span id="camid" />
      </div>

      {/* Text input section */}
      <div className="absolute bottom-20 left-5 z-[100] bg-black/80 p-4 rounded-lg">
        <div className="flex flex-col gap-2">
          <div className="text-sm text-gray-300">
            Enter a description of the object you want to query
          </div>
          <div className="flex gap-2">
            <input
              type="text"
              value={noteText}
              onChange={(e) => setNoteText(e.target.value)}
              placeholder="Enter text..."
              className="px-2 py-1 rounded bg-gray-800 text-white border border-gray-700 focus:outline-none focus:border-blue-500"
              disabled={isLoading}
            />
            <button
              onClick={handleQuery}
              className={`px-3 py-1 rounded transition-colors ${
                isLoading
                  ? "bg-gray-600 cursor-not-allowed"
                  : "bg-blue-600 hover:bg-blue-700"
              }`}
              disabled={isLoading}
            >
              {isLoading ? "Processing..." : "Query"}
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}

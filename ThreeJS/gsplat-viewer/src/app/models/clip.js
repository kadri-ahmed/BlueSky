import {
  AutoTokenizer,
  CLIPTextModelWithProjection,
} from "@huggingface/transformers";

const tokenizerPromise = AutoTokenizer.from_pretrained(
  "Xenova/clip-vit-base-patch16"
);
const textModelPromise = CLIPTextModelWithProjection.from_pretrained(
  "Xenova/clip-vit-base-patch16"
);

export async function textEmbeddingGenerator(text) {
  const tokenizer = await tokenizerPromise;
  const textModel = await textModelPromise;

  const textInputs = tokenizer([text], { padding: true, truncation: true });
  const { text_embeds } = await textModel(textInputs);

  return text_embeds.data;
}

// Helper function to calculate cosine similarity
export function cosineSimilarity(a, b) {
    if (a.length !== b.length) {
      throw new Error('Vectors must have same length');
    }
  
    const dotProduct = a.reduce((sum, ai, i) => sum + ai * b[i], 0);
    const normA = Math.sqrt(a.reduce((sum, ai) => sum + ai * ai, 0));
    const normB = Math.sqrt(b.reduce((sum, bi) => sum + bi * bi, 0));
  
    return dotProduct / (normA * normB);
  }

export const SCANNET_TEXT_LABELS = {
  0: "unlabeled",
  1: "wall",
  2: "floor",
  3: "cabinet",
  4: "bed",
  5: "chair",
  6: "sofa",
  7: "table",
  8: "door",
  9: "window",
  10: "bookshelf",
  11: "picture",
  12: "counter",
  13: "blinds",
  14: "desk",
  15: "shelves",
  16: "curtain",
  17: "dresser",
  18: "pillow",
  19: "mirror",
  20: "floormat",
  21: "clothes",
  22: "ceiling",
  23: "books",
  24: "refrigerator",
  25: "television",
  26: "paper",
  27: "towel",
  28: "showercurtain",
  29: "box",
  30: "whiteboard",
  31: "person",
  32: "nightstand",
  33: "toilet",
  34: "sink",
  35: "lamp",
  36: "bathtub",
  37: "bag",
  38: "otherstructure",
  39: "otherfurniture",
  40: "otherprop",
};
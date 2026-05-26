import * as THREE from "three";
import { SparkRenderer, SplatMesh } from "@sparkjsdev/spark";

const container = document.getElementById("app");
const loading = document.getElementById("loading");

const scene = new THREE.Scene();

const camera = new THREE.PerspectiveCamera(
  60,
  window.innerWidth / window.innerHeight,
  0.01,
  1000
);

camera.position.set(0, 0, 0);

const renderer = new THREE.WebGLRenderer({
  antialias: true,
  alpha: false,
});

renderer.setSize(window.innerWidth, window.innerHeight);

// 手机端不要太高，省电、降发热
renderer.setPixelRatio(Math.min(window.devicePixelRatio || 1, 1.5));

container.appendChild(renderer.domElement);

const spark = new SparkRenderer({ renderer });
scene.add(spark);

let currentSplat = null;

window.loadSplat = async function loadSplat(url) {
  try {
    loading.style.display = "block";
    loading.textContent = "Loading 3DGS...";

    if (currentSplat) {
      scene.remove(currentSplat);
      currentSplat = null;
    }

    currentSplat = new SplatMesh({ url });

    // 这里按你的模型实际情况调整
    currentSplat.position.set(0, 0, -3);
    currentSplat.rotation.set(0, 0, 0);
    currentSplat.scale.set(1, 1, 1);

    scene.add(currentSplat);

    loading.style.display = "none";

    if (window.FlutterBridge) {
      window.FlutterBridge.postMessage(
        JSON.stringify({
          type: "loaded",
          url,
        })
      );
    }
  } catch (e) {
    loading.textContent = "Load failed: " + e.message;

    if (window.FlutterBridge) {
      window.FlutterBridge.postMessage(
        JSON.stringify({
          type: "error",
          message: e.message,
        })
      );
    }
  }
};

// 默认加载本地模型
window.loadSplat("/models/demo.spz");

function resize() {
  camera.aspect = window.innerWidth / window.innerHeight;
  camera.updateProjectionMatrix();

  renderer.setSize(window.innerWidth, window.innerHeight);
  renderer.setPixelRatio(Math.min(window.devicePixelRatio || 1, 1.5));
}

window.addEventListener("resize", resize);

renderer.setAnimationLoop(() => {
  renderer.render(scene, camera);
});
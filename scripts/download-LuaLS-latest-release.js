const { Octokit } = require("@octokit/rest");
const fs = require("fs");
const axios = require("axios");
const decompress = require("decompress");
const { execFile } = require("child_process");
require("dns");
const path = require("path");
const os = require("os")

const octokit = new Octokit({
  auth: process.env.GITHUB_TOKEN,
});

async function downloadReleaseAssetAndUnzippedIt(owner, repo) {
  try {
    // Fetch the latest release
    const latestRelease = await octokit.rest.repos.getLatestRelease({
      owner,
      repo,
    });
    assetName = "";
    if (os.platform() === "win32")
      assetName = `lua-language-server-${latestRelease.data.tag_name}-win32-x64.zip`;
    else
      assetName = `lua-language-server-${latestRelease.data.tag_name}-linux-x64.tar.gz`;

    // Find the asset by name
    const asset = latestRelease.data.assets.find((a) => a.name === assetName);

    if (!asset) {
      throw new Error(`Asset ${assetName} not found in the latest release`);
    }

    const url = asset.browser_download_url;

    // Download the asset
    const response = await axios({
      url,
      method: "GET",
      responseType: "stream",
    });

    const writer = fs.createWriteStream(assetName);

    response.data.pipe(writer);

    writer.on("finish", () => {
      console.log(`Downloaded ${assetName}`);
      unzipAndSave(assetName, "release");
      return true;
    });

    writer.on("error", (err) => {
      fs.unlink(assetName, () => {}); // Clean up the file on error
      console.error(`Failed to download asset: ${err.message}`);
      return null;
    });
  } catch (error) {
    console.error(`Error fetching release: ${error.message}`);
    return null;
  }
}

async function unzipAndSave(assetName, dist) {
  decompress(assetName, dist)
    .then(() => {
      console.log(
        assetName + " Successfully unzipped into " + dist + " folder."
      );
      runExecutable(path.join(dist, "bin", "lua-language-server.exe"), [
        "--check",
        "C:/Users/rjha/source/repos/GitHub/tsp-toolkit-webhelp-to-json/Json_parser/bin/Debug/net48/keithley_instrument_libraries/2450",
      ]);
      return true;
    })
    .catch((error) => {
      console.log(error);
      return null;
    });
}

// Function to run an executable
function runExecutable(path, args = []) {
  execFile(path, args, (error, stdout, stderr) => {
    if (error) {
      console.error(`Error: ${error.message}`);
      return;
    }
    if (stderr) {
      console.error(`Stderr: ${stderr}`);
      return;
    }
    console.log(`Stdout: ${stdout}`);
  });
}

function testGeneratedLuaDefinitionsFiles() {
  // loop over each instrument generated lua definitions files
  // call LuaLS and generated Diagnostics json file
  // pass LuaLS configuration to config file
  runExecutable(path.join(dist, "bin", "lua-language-server.exe"), [
    "--check",
    "C:/Users/rjha/source/repos/GitHub/tsp-toolkit-webhelp-to-json/Json_parser/bin/Debug/net48/keithley_instrument_libraries/2450",
  ]);
}

function testTspScriptFiles() {
  runExecutable(path.join(dist, "bin", "lua-language-server.exe"), [
    "--check",
    "C:/Users/rjha/source/repos/GitHub/tsp-toolkit-webhelp-to-json/Json_parser/bin/Debug/net48/keithley_instrument_libraries/2450",
  ]);
}

const owner = "LuaLS"; // replace with the repository owner
const repo = "lua-language-server"; // replace with the repository name

downloadReleaseAssetAndUnzippedIt(owner, repo);

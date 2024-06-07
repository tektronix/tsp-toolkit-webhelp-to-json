const { Octokit } = require("@octokit/rest");
const fs = require("fs");
const axios = require("axios");
const decompress = require("decompress");
const { execFile } = require("child_process");
const path = require("path");
const os = require("os");
const { promisify } = require("util");
const octokit = new Octokit();

async function downloadReleaseAssetAndUnzipIt(owner, repo) {
  try {
    const latestRelease = await octokit.rest.repos.getLatestRelease({
      owner,
      repo,
    });
    const platform = os.platform();
    const assetName = `lua-language-server-${latestRelease.data.tag_name}-${
      platform === "win32" ? "win32-x64.zip" : "linux-x64.tar.gz"
    }`;
    const asset = latestRelease.data.assets.find((a) => a.name === assetName);

    if (!asset) {
      throw new Error(`Asset ${assetName} not found in the latest release`);
    }

    const response = await axios({
      url: asset.browser_download_url,
      method: "GET",
      responseType: "stream",
    });

    const writer = fs.createWriteStream(assetName);
    await new Promise((resolve, reject) => {
      response.data.pipe(writer);
      writer.on("finish", resolve);
      writer.on("error", reject);
    });

    console.log(`Downloaded ${assetName}`);
    return assetName;
  } catch (error) {
    console.error(`Error fetching release: ${error.message}`);
    throw error;
  }
}

async function unzipAndSave(assetName, dist) {
  try {
    await decompress(assetName, dist);
    console.log(`${assetName} successfully unzipped into ${dist} folder.`);
  } catch (error) {
    console.error(`Error unzipping ${assetName}: ${error.message}`);
  }
}

const execFileAsync = promisify(execFile);

async function runExecutable(exePath, args) {
  try {
    await execFileAsync(exePath, args);
    console.log(`Executed ${exePath} with arguments ${args}`);
  } catch (err) {
    console.error(`Error executing ${exePath}`, err);
  }
}

function getParentLevelFolders(directory) {
  return fs.readdirSync(directory).filter((file) => {
    const filePath = path.join(directory, file);
    return fs.statSync(filePath).isDirectory();
  });
}

async function testGeneratedLuaDefinitionsFiles(generatedLuaPath, luaLsPath) {
  try {
    deleteDirectory("testResults");
    fs.mkdirSync("testResults");

    const folders = getParentLevelFolders(generatedLuaPath);

    for (const folder of folders) {
      const testResultDir = path.join("testResults", folder);
      const workspaceDir = "workspaceDir";

      fs.mkdirSync(testResultDir);
      deleteDirectory(workspaceDir);
      fs.mkdirSync(workspaceDir);

      copyDirectory(
        path.join(generatedLuaPath, folder, "AllTspCommands"),
        workspaceDir
      );
      copyDirectory(
        path.join(generatedLuaPath, folder, "Helper"),
        workspaceDir
      );
      fs.copyFileSync(".luarc.json", path.join(workspaceDir, ".luarc.json"));

      try {
        copyDirectory(path.join("tspTestScripts", folder), workspaceDir);
      } catch (error) {
        console.error(`Error processing folder ${folder}.`, error);
      }

      await runExecutable(luaLsPath, ["--check", workspaceDir]);

      try {
        fs.copyFileSync(
          path.join("release", "log", "check.json"),
          path.join(testResultDir, "Diagnostics.json")
        );
      } catch (err) {
        console.error(`Error processing folder ${folder}.`, err);
      }
    }
  } catch (error) {
    console.error(`Error in test generation: ${error.message}`);
  } finally {
    deleteDirectory("workspaceDir");
  }
}

function deleteDirectory(dirPath) {
  try {
    fs.rmSync(dirPath, { recursive: true, force: true });
    console.log(`${dirPath} is deleted!`);
  } catch (err) {
    console.error(`Error while deleting ${dirPath}.`, err);
  }
}

function copyDirectory(src, dest) {
  fs.cpSync(src, dest, { recursive: true });
}

async function main() {
  const owner = "LuaLS";
  const repo = "lua-language-server";
  const generatedLuaPath = process.argv[2];

  if (!generatedLuaPath) {
    console.error(
      "Please provide the path to the generated Lua definition folder."
    );
    process.exit(1);
  }

  console.log(`Generated Lua definition folder path: ${generatedLuaPath}`);
  deleteDirectory("release");

  try {
    const assetName = await downloadReleaseAssetAndUnzipIt(owner, repo);
    await unzipAndSave(assetName, "release");

    const luaLSPath =
      os.platform() === "win32"
        ? path.join("release", "bin", "lua-language-server.exe")
        : path.join("release", "bin", "lua-language-server");

    await testGeneratedLuaDefinitionsFiles(generatedLuaPath, luaLSPath);
    deleteDirectory(assetName);
  } catch (error) {
    console.error(`Error in download and unzip process: ${error.message}`);
  }
}

main();

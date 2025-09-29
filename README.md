# Tools

<details>
<summary>File manager 100 files per folder</summary>
  
```
python3 -c "import os,shutil; files=sorted([f for f in os.listdir('.') if os.path.isfile(f)]); [ (os.makedirs(str(i//100+1),exist_ok=True), [shutil.move(f,os.path.join(str(i//100+1),f)) for f in files[i:i+100]]) for i in range(0,len(files),100) ]"
```
</details>

---

<details>
  <summary>WEBP convertor for COLAB</summary>
  
```
import os
from PIL import Image
import random
import string

base_dir = "/content/images"

# Step 1: convert to .webp and delete originals
for root, dirs, files in os.walk(base_dir):
    for file in files:
        path = os.path.join(root, file)
        out_path = os.path.splitext(path)[0] + ".webp"
        try:
            with Image.open(path) as im:
                im.convert("RGB").save(out_path, "webp", quality=80, method=6)
            if out_path != path:
                os.remove(path)
        except Exception as e:
            print(f"skip {path}: {e}")

# Step 2: rename all .webp files to unique random 6-char alphanumeric names
def random_name(existing_names):
    while True:
        name = ''.join(random.choices(string.ascii_letters + string.digits, k=6))
        if name not in existing_names:
            return name

for root, dirs, files in os.walk(base_dir):
    files = [f for f in files if f.lower().endswith(".webp")]
    existing_names = set()
    for file in files:
        new_name = random_name(existing_names) + ".webp"
        existing_names.add(new_name[:-5])  # store without extension
        old_path = os.path.join(root, file)
        new_path = os.path.join(root, new_name)
        os.rename(old_path, new_path)

print("All images converted to WEBP and renamed with random names.")

```
</details>

---

<details>
  <summary>Folder to JSON</summary>
  
```
import os
import json

base_dir = "/content/downloads"
output_json = "/content/final_index.json"

result = {}

for user in sorted(os.listdir(base_dir)):
    folder = os.path.join(base_dir, user)
    if os.path.isdir(folder):
        files = [f for f in os.listdir(folder) if f.lower().endswith(".webp")]
        files.sort()
        result[user] = files

with open(output_json, "w") as f:
    json.dump(result, f, indent=2)

print(f"JSON saved to {output_json}")
```
</details>

---

<details>
<summary>Zip folder</summary>

```
!zip -0 -r /content/downloads.zip /content/downloads
```
</details>

---

<details>
  <summary>Coomer.su : Console Command</summary>

```
const urlParts = location.href.split('/');
const username = urlParts[urlParts.length - 1] || urlParts[urlParts.length - 2];

const service = "onlyfans";
const apiBase = `https://coomer.st/api/v1/${service}/user/${username}/posts?o=`;
let allUrls = [];

async function fetchAll(offset = 0) {
  const res = await fetch(apiBase + offset, {
    headers: {
      "Accept": "text/css",  // bypass trick
      "User-Agent": navigator.userAgent,
      "Referer": location.href
    }
  });

  if (!res.ok) {
    console.log("✅ Finished scraping. Total:", allUrls.length);
    saveTxt();
    return;
  }

  const posts = await res.json().catch(() => []);
  if (!posts.length) {
    console.log("✅ No more posts. Total:", allUrls.length);
    saveTxt();
    return;
  }

  for (const post of posts) {
    if (post.file?.path) {
      allUrls.push("https://img.coomer.st/thumbnail/data" + post.file.path);
    }
    for (const att of (post.attachments || [])) {
      if (att.path) {
        allUrls.push("https://img.coomer.st/thumbnail/data" + att.path);
      }
    }
  }

  console.log(`Fetched offset ${offset}, total so far: ${allUrls.length}`);
  await fetchAll(offset + 50);
}

function saveTxt() {
  if (!allUrls.length) {
    console.log("⚠️ No URLs collected.");
    return;
  }
  const blob = new Blob([allUrls.join("\n")], { type: "text/plain" });
  const url = URL.createObjectURL(blob);
  const a = document.createElement("a");
  a.href = url;
  a.download = `${username}_urls.txt`;
  document.body.appendChild(a);
  a.click();
  document.body.removeChild(a);
  URL.revokeObjectURL(url);
  console.log("💾 Download started:", `${username}_urls.txt`);
}

fetchAll();
```
</details>

---

<details>
<summary>Url downlader jut put the 'urls.txt' </summary>

```
# Install requirements
!pip install aiohttp aiofiles tqdm -q

import aiohttp
import aiofiles
import asyncio
import os
import zipfile
from tqdm.asyncio import tqdm

# File containing URLs
url_file = "/content/urls.txt"

# Output folder
out_dir = "/content/images"
os.makedirs(out_dir, exist_ok=True)

# Read URLs
with open(url_file, "r") as f:
    urls = [line.strip() for line in f if line.strip()]

# Download worker
async def download_image(session, url):
    try:
        filename = os.path.basename(url.split("?")[0])
        filepath = os.path.join(out_dir, filename)

        async with session.get(url) as resp:
            if resp.status == 200:
                async with aiofiles.open(filepath, 'wb') as f:
                    await f.write(await resp.read())
            else:
                print(f"❌ Failed: {url} ({resp.status})")
    except Exception as e:
        print(f"⚠️ Error: {url} - {e}")

# Main async runner
async def main():
    connector = aiohttp.TCPConnector(limit=20)  # parallel workers
    async with aiohttp.ClientSession(connector=connector) as session:
        tasks = [download_image(session, url) for url in urls]
        for f in tqdm(asyncio.as_completed(tasks), total=len(tasks), desc="Downloading"):
            await f

# Run downloader
await main()

# Zip results
zip_path = "/content/images.zip"
with zipfile.ZipFile(zip_path, 'w') as zipf:
    for root, _, files in os.walk(out_dir):
        for file in files:
            zipf.write(os.path.join(root, file), file)

print(f"✅ Download complete! ZIP saved at: {zip_path}")
```

  
</details>


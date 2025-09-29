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

base_dir = "/content/downloads"

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

# Step 2: rename as 001.webp, 002.webp, ...
for root, dirs, files in os.walk(base_dir):
    files = [f for f in files if f.lower().endswith(".webp")]
    files.sort()
    for i, file in enumerate(files, 1):
        new_name = f"{i:03}.webp"
        old_path = os.path.join(root, file)
        new_path = os.path.join(root, new_name)
        os.rename(old_path, new_path)

print("All images converted to WEBP and renamed.")
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


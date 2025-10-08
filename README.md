# Tools

<details>
  <summary>website AI instr.</summary>
  
  ```
- Always make JavaScript components reusable.
- Fix the mobile navigation bar buttons so they automatically switch to dark mode. Add <meta name="color-scheme" content="light dark"> and use media-specific <meta name="theme-color"> tags for light and dark modes. Ensure the navigation bar color updates correctly on Android/iOS by adding a small JavaScript snippet that listens for prefers-color-scheme changes and updates the theme-color in real time.
- Use Tailwind CSS.

Always provide a sticky, top header with a left-aligned site logo (glassy blur theme).

Optimize the site for both mobile and desktop views.
  ```
</details>

---
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


<details>
<summary>Kemono.su</summary>
  
```
const urlParts = location.href.split('/');
const creator_id = urlParts[urlParts.length - 1] || urlParts[urlParts.length - 2];

const service = "patreon"; // or "fanbox", "fantia", etc. depending on the URL
const apiBase = `https://kemono.cr/api/v1/${service}/user/${creator_id}/posts`;
let allUrls = [];

async function fetchAll(offset = 0) {
  const res = await fetch(`${apiBase}?o=${offset}`, {
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
    // Handle main file
    if (post.file?.path) {
      allUrls.push("https://kemono.cr" + post.file.path);
    }
    
    // Handle attachments
    for (const att of (post.attachments || [])) {
      if (att.path) {
        allUrls.push("https://kemono.cr" + att.path);
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
  a.download = `${creator_id}_urls.txt`;
  document.body.appendChild(a);
  a.click();
  document.body.removeChild(a);
  URL.revokeObjectURL(url);
  console.log("💾 Download started:", `${creator_id}_urls.txt`);
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

---

<details>
  
```
import requests
import json
import os

def get_username_from_input(user_input):
    """Extracts a username from either a full Coomer URL or just a username string."""
    if "coomer.st/" in user_input:
        parts = user_input.strip('/').split('/')
        if 'user' in parts:
            return parts[parts.index('user') + 1]
    
    print("Input was not a full URL, assuming it's a username.")
    return user_input.strip()

def fetch_all_posts(username, service="onlyfans"):
    """Fetches all post data with robust headers."""
    api_base = f"https://coomer.st/api/v1/{service}/user/{username}/posts"
    offset = 0
    limit = 50
    all_posts = []
    
    print(f"\nStarting to fetch data for user: {username}")

    primary_headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
        "Accept": "application/json, text/plain, */*",
        "Accept-Language": "en-US,en;q=0.9",
        "Referer": f"https://coomer.st/{service}/user/{username}",
        "Origin": "https://coomer.st",
    }
    
    fallback_headers = {
        "Accept": "text/css",
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
        "Referer": f"https://coomer.st/{service}/user/{username}"
    }
    
    headers_to_use = primary_headers
    print("Attempting with primary browser headers...")

    while True:
        api_url = f"{api_base}?o={offset}"
        
        try:
            response = requests.get(api_url, headers=headers_to_use, timeout=20)
            
            if response.status_code == 403 and headers_to_use is primary_headers:
                print("❌ Got 403 Forbidden. Retrying with fallback headers...")
                headers_to_use = fallback_headers
                continue

            response.raise_for_status()
            
            posts = response.json()
            
            if not posts:
                print("✅ No more posts found. Finished scraping.")
                break
                
            all_posts.extend(posts)
            print(f"Fetched page with offset {offset}, found {len(posts)} posts. Total posts so far: {len(all_posts)}")
            
            offset += limit
            
        except requests.exceptions.RequestException as e:
            print(f"⚠️ Stopping fetch due to an error: {e}")
            break
        except json.JSONDecodeError:
            print(f"❌ Failed to decode JSON at offset {offset}. The response might be empty or invalid.")
            break
            
    return all_posts

def get_media_details(path):
    """Fetches file details (like size) from the Coomer API for a given path."""
    if not path:
        return None
    try:
        detail_url = f"https://coomer.st/api/v1/posts/file{path}"
        res = requests.get(detail_url, timeout=10)
        if res.ok:
            return res.json()
    except requests.exceptions.RequestException:
        # Silently fail if we can't get details
        pass
    return None

def extract_and_filter_media(posts, max_images=250, max_videos=10, max_video_size_mb=23):
    """
    Extracts, filters, and prioritizes media URLs.
    This version is optimized: it prioritizes videos FIRST, then checks the size
    on a smaller subset to find the final list.
    """
    image_urls = []
    video_paths = []
    video_extensions = ['.mp4', '.mov', '.mkv', '.m4a', '.webm', '.avi', 'm4v']
    
    print("\nProcessing and filtering media files...")
    
    for post in posts:
        # Process main file
        if post.get("file") and post["file"].get("path"):
            path = post["file"]["path"]
            if any(path.lower().endswith(ext) for ext in video_extensions):
                video_paths.append(path)
            else:
                image_urls.append("https://img.coomer.st/thumbnail/data" + path)
        
        # Process attachments
        for attachment in post.get("attachments", []):
            if attachment.get("path"):
                path = attachment["path"]
                if any(path.lower().endswith(ext) for ext in video_extensions):
                    video_paths.append(path)
                else:
                    image_urls.append("https://img.coomer.st/thumbnail/data" + path)
    
    # --- Filter and select images ---
    final_image_urls = image_urls[:max_images]
    print(f"Found {len(image_urls)} images. Selected the first {len(final_image_urls)}.")
    
    # --- Prioritize and select videos (THE OPTIMIZED PART) ---
    print(f"Found {len(video_paths)} total videos. Prioritizing...")
    
    # 1. Define priority for sorting
    def get_video_priority(path):
        path = path.lower()
        if path.endswith('.mp4'):
            return 0
        if path.endswith('.m4a'):
            return 1
        return 2 # All other video formats

    # 2. Sort all video paths by priority
    video_paths.sort(key=get_video_priority)
    
    # 3. Take a larger sample of the top-priority videos to check for size
    # This avoids checking the size of hundreds or thousands of files.
    sample_size = max_videos * 5  # Check the top 50 to find 10 good ones
    top_video_candidates = video_paths[:sample_size]
    
    print(f"Checking file sizes for the top {len(top_video_candidates)} candidate videos...")
    
    # 4. Filter this smaller list by size
    final_video_urls = []
    for path in top_video_candidates:
        details = get_media_details(path)
        if details:
            size_mb = details.get('size', 0) / (1024 * 1024)
            if size_mb < max_video_size_mb:
                final_video_urls.append(f"https://n3.coomer.st/data{path}")
                if len(final_video_urls) >= max_videos:
                    break # Stop once we have enough videos
    
    print(f"Selected the top {len(final_video_urls)} videos by priority and size (<{max_video_size_mb}MB).")
    
    return final_image_urls, final_video_urls

def save_to_file(urls, username):
    """Saves URLs to a text file in the Colab environment and prints its location."""
    if not urls:
        print("⚠️ No URLs were collected to save.")
        return None
        
    save_path = "/content/drive/MyDrive/temp/username"
    filename = f"{username}.txt"
    full_path = os.path.join(save_path, filename)
    
    with open(full_path, 'w') as f:
        f.write('\n'.join(urls))
    
    print(f"\n✅ Successfully saved a total of {len(urls)} media URLs to the file:")
    print(f"📁 {full_path}")
    print("\nYou can find this file in the file browser panel on the left side of Colab.")
    
    return full_path

# --- Main Execution ---
user_input = input("Enter the Coomer.st URL or just the username (e.g., joslynjames): ")
username = get_username_from_input(user_input)

if not username:
    print("❌ Could not determine a username from the input.")
else:
    print(f"✅ Using username: {username}")
    
    all_posts_data = fetch_all_posts(username)
    
    if all_posts_data:
        # Extract and filter media according to the new, optimized rules
        images, videos = extract_and_filter_media(all_posts_data)
        
        # Combine the final lists of URLs
        final_urls = images + videos
        
        if final_urls:
            save_to_file(final_urls, username)
        else:
            print("❌ No media URLs met the specified criteria to be saved.")
    else:
        print("❌ Could not retrieve any posts for this user.")
```

```
import os
import requests
import concurrent.futures
from pathlib import Path

# --- Configuration ---
# The folder where your .txt files are located
SOURCE_DIR = "/content/drive/MyDrive/temp/username"
# The main folder where downloaded content will be saved
DESTINATION_BASE_DIR = "/content/drive/MyDrive/temp/main"
# Number of parallel downloads
MAX_WORKERS = 10
# Timeout for each download attempt in seconds
DOWNLOAD_TIMEOUT = 60

# --- Downloader Functions ---

def download_file(url, destination_path):
    """Downloads a single file to the specified path."""
    try:
        # Create the destination directory if it doesn't exist
        Path(destination_path).parent.mkdir(parents=True, exist_ok=True)
        
        # Check if file already exists to avoid re-downloading
        if os.path.exists(destination_path):
            print(f"SKIPPING (already exists): {os.path.basename(destination_path)}")
            return True

        headers = {
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
        }
        
        print(f"DOWNLOADING: {os.path.basename(destination_path)}")
        with requests.get(url, headers=headers, stream=True, timeout=DOWNLOAD_TIMEOUT) as r:
            r.raise_for_status()
            with open(destination_path, 'wb') as f:
                for chunk in r.iter_content(chunk_size=8192):
                    f.write(chunk)
        return True
    except requests.exceptions.RequestException as e:
        print(f"❌ FAILED to download {os.path.basename(destination_path)}: {e}")
        return False
    except Exception as e:
        print(f"❌ An unexpected error occurred with {os.path.basename(destination_path)}: {e}")
        return False

def process_creator(txt_file_path):
    """Reads a creator's txt file and downloads all listed URLs."""
    creator_name = Path(txt_file_path).stem
    print(f"\n{'='*50}")
    print(f"🚀 STARTING PROCESS FOR CREATOR: {creator_name}")
    print(f"{'='*50}")

    # Create subdirectories for this creator
    creator_img_dir = os.path.join(DESTINATION_BASE_DIR, creator_name, "imgs")
    creator_vid_dir = os.path.join(DESTINATION_BASE_DIR, creator_name, "vids")
    Path(creator_img_dir).mkdir(parents=True, exist_ok=True)
    Path(creator_vid_dir).mkdir(parents=True, exist_ok=True)

    try:
        with open(txt_file_path, 'r') as f:
            urls = [line.strip() for line in f if line.strip()]
    except Exception as e:
        print(f"❌ Could not read file {txt_file_path}: {e}")
        return

    if not urls:
        print(f"⚠️ No URLs found in {txt_file_path}. Skipping.")
        return

    download_tasks = []
    for url in urls:
        filename = os.path.basename(url)
        if not filename:
            continue

        # Determine destination based on file extension
        if any(filename.lower().endswith(ext) for ext in ['.mp4', '.mov', '.mkv', '.m4a', '.webm', '.avi']):
            dest_path = os.path.join(creator_vid_dir, filename)
        else:
            dest_path = os.path.join(creator_img_dir, filename)
        
        download_tasks.append((url, dest_path))

    # Use ThreadPoolExecutor to download files in parallel
    with concurrent.futures.ThreadPoolExecutor(max_workers=MAX_WORKERS) as executor:
        # map() runs the download_file function for each item in download_tasks
        # It maintains order and waits for all to complete
        list(executor.map(download_file, *zip(*download_tasks)))
        
    print(f"\n✅ FINISHED PROCESSING: {creator_name}")


def main():
    """Main function to find all txt files and start processing."""
    print("Starting the download manager...")
    
    # Ensure the source directory exists
    if not os.path.isdir(SOURCE_DIR):
        print(f"❌ ERROR: Source directory not found at '{SOURCE_DIR}'")
        print("Please check the path and make sure you have mounted your Google Drive.")
        return

    # Find all .txt files in the source directory
    txt_files = [os.path.join(SOURCE_DIR, f) for f in os.listdir(SOURCE_DIR) if f.endswith('.txt')]
    
    if not txt_files:
        print(f"⚠️ No .txt files found in '{SOURCE_DIR}'. Nothing to do.")
        return
        
    print(f"Found {len(txt_files)} creator files to process.")
    
    # Process each creator file one by one
    for txt_file in txt_files:
        process_creator(txt_file)

    print("\n🎉 ALL TASKS COMPLETED!")

# Run the main function
if __name__ == "__main__":
    main()
```

</details>

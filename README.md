### Utility


```bash
python3 -c "import os,shutil; files=sorted([f for f in os.listdir('.') if os.path.isfile(f)]); [ (os.makedirs(str(i//100+1),exist_ok=True), [shutil.move(f,os.path.join(str(i//100+1),f)) for f in files[i:i+100]]) for i in range(0,len(files),100) ]"
```

---

✅ This will:

* Take all files in the **current folder**.
* Create subfolders: `1`, `2`, `3`, …
* Move **100 files per folder**.


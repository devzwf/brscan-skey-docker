"""Assemble TIFF pages into one PDF: JPEG for gray/colour, CCITT G4 for black & white."""
import io, os, sys
import img2pdf
from PIL import Image

out, pages = sys.argv[1], sys.argv[2:]
res = int(os.environ.get("SCAN_RESOLUTION", "300"))
quality = int(os.environ.get("JPEG_QUALITY", "80"))

blobs = []
for path in pages:
    im = Image.open(path)
    im.load()
    dpi = tuple(int(round(float(v))) for v in im.info.get("dpi", (res, res))) or (res, res)
    buf = io.BytesIO()
    if im.mode == "1":
        im.save(buf, format="TIFF", compression="group4", dpi=dpi)
    else:
        if im.mode not in ("L", "RGB"):
            im = im.convert("RGB")
        im.save(buf, format="JPEG", quality=quality, optimize=True, dpi=dpi)
    blobs.append(buf.getvalue())

with open(out, "wb") as f:
    f.write(img2pdf.convert(blobs))

# image_join

A Bash script to join two images either horizontally (side-by-side) or vertically (stacked), automatically matching their heights or widths as needed.

## Requirements

- [ImageMagick](https://imagemagick.org/)
- Bash

## Usage

```sh
image_join -h <image1> <image2>   # Join images horizontally (side-by-side), match height
image_join -v <image1> <image2>   # Join images vertically (stacked), match width
```

- **-h**: Join images side-by-side, matching their heights.
- **-v**: Join images stacked, matching their widths.

## Output

- For horizontal join (`-h`):  
  `./JoinedImages/<name1>_<name2>_side.png`
- For vertical join (`-v`):  
  `./JoinedImages/<name1>_<name2>.png`

## Example

```sh
./image_join -h cat.png dog.jpg
# Output: ./JoinedImages/cat_dog_side.png

./image_join -v cat.png dog.jpg
# Output: ./JoinedImages/cat_dog.png
```

## Notes

- Both input files must exist and be valid image files.
- Output images are always saved as PNG in the `JoinedImages` directory (created if it doesn't exist).
- The script will resize images as needed to match heights (for horizontal) or widths (for vertical).

---

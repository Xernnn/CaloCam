# Reference card dataset

The 310 photos this model was trained on are not in the public repository: they show real bank,
citizen ID, student and other cards, with names and numbers on them. The YOLO labels are here
(`train/labels`, `val/labels`), one text file per photo.

To retrain, take your own photos of 85.6 × 53.98 mm cards (ID-1 size) on a table, label them with
Label Studio or any YOLO labelling tool, and put them in `train/images` and `val/images`.

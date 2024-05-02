from ultralytics import YOLO
import cv2

model = YOLO("best.pt")
threshold = 0.9  # Change the threshold value to 0.9
frame = cv2.imread('image/img58.jpg')
# frame = cv2.imread('images/img_2.jpg')
results = model(frame)[0]

for result in results.boxes.data.tolist():
    x1, y1, x2, y2, score, class_id = result

    if score > threshold:
        cv2.rectangle(frame, (int(x1), int(y1)), (int(x2), int(y2)), (0, 255, 0), 4)
        cv2.putText(frame, results.names[int(class_id)].upper(), (int(x1), int(y1 - 10)),
                    cv2.FONT_HERSHEY_SIMPLEX, 1.3, (0, 255, 0), 3, cv2.LINE_AA)
        cv2.circle(frame, (int(x1), int(y1)), 4, (0, 0, 255), -1)
        cv2.circle(frame, (int(x2), int(y2)), 4, (0, 0, 255), -1)

        print("width:", abs(x2 - x1))
        print("height:", abs(y2 - y1))

frame = cv2.resize(frame, (640, 480))
cv2.imshow("frame", frame)
cv2.waitKey(0)

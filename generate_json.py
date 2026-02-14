import csv
import json

def process_survey_data(csv_filepath, json_filepath):
    data = []

    with open(csv_filepath, 'r') as csvfile:
        reader = csv.DictReader(csvfile)
        # Get fieldnames (class names) - skip 'Student ID'
        fieldnames = reader.fieldnames
        if not fieldnames:
            print("No headers found in CSV.")
            return

        class_names = [f for f in fieldnames if f != 'Student ID']

        # Initialize counts and sums
        stats = {cls: {'sum': 0, 'count': 0} for cls in class_names}

        for row in reader:
            for cls in class_names:
                try:
                    val = float(row[cls])
                    stats[cls]['sum'] += val
                    stats[cls]['count'] += 1
                except ValueError:
                    pass # Skip non-numeric or empty values

    # Calculate averages and format for JSON
    json_data = []
    for cls in class_names:
        avg = stats[cls]['sum'] / stats[cls]['count'] if stats[cls]['count'] > 0 else 0
        json_data.append({
            "className": cls,
            "averageRating": round(avg, 2),
            "studentCount": stats[cls]['count']
        })

    # Sort by average rating descending (optional but good for the chart)
    json_data.sort(key=lambda x: x['averageRating'], reverse=True)

    with open(json_filepath, 'w') as jsonfile:
        json.dump(json_data, jsonfile, indent=4)

    print(f"Data processed and exported to {json_filepath}")

if __name__ == "__main__":
    process_survey_data('Grad Program Exit Survey Data 2024.csv', 'data.json')

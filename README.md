# NYC-Yellow-Taxi-Graph-project-using-NEo4j-Docker

🚕 NYC Yellow Taxi Trip Graph Project
This project loads NYC Yellow Taxi trip data into a Neo4j graph database using Docker and performs graph analysis using PageRank and Breadth-First Search (BFS). The analysis focuses specifically on trips that start and end in the Bronx.

📦 Project Structure

├── Dockerfile

├── data_loader.py

├── interface.py

├── tester.py

├── yellow_tripdata_2022-03.parquet 

├── neo4j-graph-data-science-2.15.0.jar

└── Schema-data_dictionary_trip_records_yellow.pdf

🔧 Setup Instructions

1. Build Docker Image
 run in vs code terminal : docker build -t neo4j_project .

2. Run Docker Container
docker run -it --rm --name neo4j_project_container -p 7474:7474 -p 7687:7687 neo4j_project

NOTE : Neo4j browser UI will be available at http://localhost:7474

🔍 Description
The data_loader.py script loads the yellow_tripdata_2022-03.parquet file, filters and cleans the data, and loads Bronx-based trip data into the Neo4j database.
The Neo4j nodes represent locations (PULocationID, DOLocationID) and the edges represent trips between them, with properties like distance, fare, pickup and dropoff time.
Neo4j GDS Plugin v2.15.0 is manually installed in the container and configured for unrestricted usage.

⚙️ Graph Algorithms Implemented
🔹 PageRank
Implemented in interface.py using Neo4j GDS.

Tests are written in tester.py to validate the top and bottom ranked nodes.
The script confirms that 42 nodes exist and verifies PageRank scores.
The [0] and [-1] indexes are used to test the first and last ranked nodes respectively.

Expected:
First node: 159 with score ≈ 3.22825
Last node: 59 with score ≈ 0.18247

🔹 Breadth-First Search (BFS)
Finds the shortest path between two Bronx locations using BFS.
Start Node: 159
End Node: 212
Validated in tester.py using path traversal logic and node comparison:
First node: result[0]['path'][0]['name']
Last node: result[0]['path'][-1]['name']

✅ Testing
Run:
python tester.py

 Expected Ouput :
Count of Nodes: 42 → PASS
Count of Edges: 1530 → PASS
PageRank Test: PASS
BFS Test: PASS

📚 Data Reference
Dataset: NYC TLC Yellow Taxi Trip Data - March 2022
Schema: Schema-data_dictionary_trip_records_yellow.pdf for understanding the dataset

📌 Notes
Data filtered for Bronx zones only.
Docker handles Neo4j installation, plugin setup, and Python environment.
Graph Data Science Plugin added manually: neo4j-graph-data-science-2.15.0.jar

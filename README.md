# Parquet Data Query Tool (Browser-Based)

## Overview

This project provides a lightweight, browser-based tool for querying large datasets stored in Parquet format. Leveraging the power of DuckDB WebAssembly (WASM), users can directly query Parquet files hosted on various cloud storage providers (e.g., AWS S3, Cloudflare R2, Google Cloud Storage, Azure Blob Storage) or any publicly accessible HTTP(S) URL, without requiring any server-side backend for query processing.

The application is a single HTML file that can be hosted on any static web hosting service or run locally. It's designed to be a cost-effective solution for ad-hoc data exploration and analysis of large Parquet files.

## Features

*   **Two Query Modes:** A "Basic" mode for single-file queries and an "Advanced" mode for multi-file queries.
*   **Flexible Data Loading:** Load Parquet files from public URLs or from your local machine.
*   **Multi-File Queries:** In Advanced Mode, load multiple Parquet files and query them as separate tables.
*   **AI-Powered Query Generation:** In Advanced Mode, write natural language prompts (e.g., "show me the first 10 rows") and have an AI assistant generate the SQL for you.
*   **Automatic Schema Detection:** The tool automatically inspects the Parquet file and displays its schema.
*   **Custom SQL Execution:** Write and run your own custom SQL queries against the loaded data.
*   **Client-Side Processing:** All query processing is done in the user's browser using DuckDB-WASM. No server-side computation is needed.
*   **Deploy Anywhere:** As a single HTML file, the tool can be hosted on any static web hosting service or run locally.

## Usage

The tool has two main modes: **Basic** for single-file analysis and **Advanced** for multi-file queries and AI-powered features.

### Basic Mode

This mode is for quickly querying a single Parquet file.

1.  **Select Data Source:** Choose to load a file from a URL or your local machine.
2.  **Load Data:** Provide the URL or select the local `.parquet` file, then click **Load File**. The tool will load the data and display the detected column names.
3.  **Build Query:**
    *   Select one or more columns from the dropdown.
    *   In the text area, add any SQL clauses like `WHERE`, `GROUP BY`, `ORDER BY`, or `LIMIT`.
4.  **Run Query:** Click **Run Query** to see the results.

### Advanced Mode

This mode allows you to load multiple files and use the AI assistant.

1.  **Add Files:**
    *   For each file, assign a **Unique Name** that will be used as its table name in your queries.
    *   Select the source (URL or Local) and provide the file.
    *   Click **Add File** to add more file inputs.
2.  **Load Files:** Once all files are configured, click **Load Files**.
3.  **Write Query:** You have two options:
    *   **Manual SQL:** Write a standard SQL query in the **Custom Query** text area, referencing the files by the unique names you provided.
    *   **AI Assistant:** In the **Natural Language Query** text area, write a plain-English request (e.g., "show me the first 20 rows from the sales table"). Click **Generate Query**, and the AI will write the SQL for you.
4.  **Run Query:** Click **Run Query** to execute the query in the text area and view the results.

## Deployment

### 1. Static Site Hosting

Since the application is a single `index.html` file (with all JavaScript and CSS embedded or loaded from CDNs), it's ideal for static site hosting platforms:

*   **GitHub Pages:** Fork the repository (if applicable) or create a new one, push `index.html`, and enable GitHub Pages in the repository settings.
*   **Cloudflare Pages:** Connect your Git repository to Cloudflare Pages and deploy.
*   **Netlify, Vercel, AWS S3 (as a static website), etc.:** Most static hosting providers will work. Simply upload the `index.html` file.

### 2. Docker

A `Dockerfile` is provided to containerize the application using Nginx to serve the `index.html` file.

1.  **Build the Docker image:**
    ```bash
    docker build -t parquet-query-tool .
    ```
2.  **Run the Docker container:**
    ```bash
    docker run -d -p 8080:80 parquet-query-tool
    ```
    The application will be accessible at `http://localhost:8080`.
### 🖥️ Running Locally

Since this is a client-side application, you can run it locally without any complex setup.

#### 📁 Steps to Run

- **Create a new folder** on your computer.
- **Download** the `index.html` file and place it inside the new folder.
- **Start a simple web server**:
   - Open your terminal or command prompt.
   - Navigate into the folder.
   - If you have Python installed, run:
     ```bash
     python -m http.server
     ```
- **Open your web browser** and go to:
   - `http://127.0.0.1:8000` or
   - `http://localhost:8000`

You should now see the application running.

#### ⚠️ Note

While you can open the `index.html` file directly in the browser, some browser security policies may restrict functionality when run as a local file (`file:///...`). **Running it from a local web server is the recommended approach.**

---

## Important Note on CORS

Cross-Origin Resource Sharing (CORS) is a security feature implemented by web browsers that restricts web pages from making requests to a different domain than the one that served the page.

**For this tool to work, the server hosting the Parquet file MUST be configured to allow requests from the origin where `index.html` is being accessed.**

*   **`Access-Control-Allow-Origin`:** This response header from the Parquet file's server should include the domain of your `index.html` page or be `*` (wildcard, less secure but often used for public data).
*   **`Access-Control-Allow-Methods`:** Should typically include `GET` and `HEAD`.
*   **`Access-Control-Allow-Headers`:** May need to be configured if DuckDB WASM sends specific headers, though for simple GET requests, this is often less of an issue.

**If CORS is not configured correctly on the data server, you will see errors in your browser's developer console, and the data will not load.**

### Example CORS Configuration (AWS S3)

```xml
<CORSConfiguration>
 <CORSRule>
   <AllowedOrigin>*</AllowedOrigin>
   <AllowedMethod>GET</AllowedMethod>
   <AllowedMethod>HEAD</AllowedMethod>
   <MaxAgeSeconds>3000</MaxAgeSeconds>
   <AllowedHeader>*</AllowedHeader>
 </CORSRule>
</CORSConfiguration>
```

Consult the documentation for your specific cloud provider or HTTP server on how to configure CORS.

## Future Enhancements (Ideas)

*   **Advanced Filtering/Aggregation UI:** Provide UI elements to build filters and aggregations without writing raw SQL.
*   **Data Visualization:** Integrate basic charting libraries (e.g., Chart.js) to visualize query results.
*   **Download Results:** Allow users to download query results (e.g., as CSV).
```

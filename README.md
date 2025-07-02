# Parquet Data Query Tool (Browser-Based)

## Overview

This project provides a lightweight, browser-based tool for querying large datasets stored in Parquet format. Leveraging the power of DuckDB WebAssembly (WASM), users can directly query Parquet files hosted on various cloud storage providers (e.g., AWS S3, Cloudflare R2, Google Cloud Storage, Azure Blob Storage) or any publicly accessible HTTP(S) URL, without requiring any server-side backend for query processing.

The application is a single HTML file that can be hosted on any static web hosting service or run locally. It's designed to be a cost-effective solution for ad-hoc data exploration and analysis of large Parquet files.

## Features

*   **Query Remote Parquet Files:** Directly query Parquet files from any HTTP(S) URL.
*   **Client-Side Processing:** All query processing is done in the user's browser using DuckDB WASM. No server-side computation resources are needed for querying.
*   **Zero Backend (for Querying):** The core query functionality doesn't rely on a backend application server.
*   **SQL Interface:** Use standard SQL syntax to query data.
*   **Basic Table Display:** View query results in a simple HTML table.
*   **Deploy Anywhere:** Host as a static site (GitHub Pages, Cloudflare Pages, etc.) or run via Docker.
*   **Cost-Effective:** Minimal hosting costs, especially when using free static site providers and leveraging existing storage.

## How it Works

1.  **User Provides URL:** The user inputs the HTTP(S) URL of a Parquet file.
2.  **DuckDB WASM:** The browser loads DuckDB compiled to WebAssembly.
3.  **Direct HTTP Request:** DuckDB makes an HTTP GET request (potentially with range requests for partial reads) to fetch the Parquet file data directly from the provided URL.
4.  **Client-Side Query Execution:** The SQL query (currently a `SELECT * ... LIMIT 10`) is executed entirely within the browser against the fetched data.
5.  **Results Displayed:** The query results are rendered in an HTML table.

**Crucial Dependency: CORS (Cross-Origin Resource Sharing)**
For this tool to access a Parquet file from a given URL, the server hosting that file *must* be configured with appropriate CORS headers. Specifically, the `Access-Control-Allow-Origin` header must permit requests from the domain where this HTML tool is hosted (or be set to `*` to allow all origins). Without correct CORS policies on the data host, browsers will block these cross-origin requests as a security measure.

## Prerequisites

*   A modern web browser that supports WebAssembly (most current browsers do).
*   The Parquet file you want to query must be accessible via an HTTP(S) URL.
*   **Correct CORS configuration** on the server hosting the Parquet file.

## Getting Started / Usage

1.  **Obtain the `index.html` file.**
2.  **Open `index.html` in your web browser:**
    *   You can open it directly as a local file (`file:///path/to/index.html`).
    *   For development or to ensure proper module loading, you might serve it via a local HTTP server (e.g., `python -m http.server`).
3.  **Enter Parquet File URL:** In the input field labeled "Parquet File URL:", paste the full HTTP(S) URL to your `.parquet` file.
    *   Example: `https://data-crimedecoder.com/books.parquet` (This is a publicly accessible test file with open CORS).
4.  **Run Query:** Click the "Run Query" button.
5.  **View Results:** The first 10 rows of the Parquet file will be displayed in the table below.

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

*   **Custom SQL Queries:** Allow users to input their own SQL queries instead of a fixed `LIMIT 10`.
*   **Advanced Filtering/Aggregation UI:** Provide UI elements to build filters and aggregations without writing raw SQL.
*   **Data Visualization:** Integrate basic charting libraries (e.g., Chart.js) to visualize query results.
*   **Schema Viewer:** Display the schema of the Parquet file.
*   **Download Results:** Allow users to download query results (e.g., as CSV).
*   **Improved Error Handling and User Feedback.**
```

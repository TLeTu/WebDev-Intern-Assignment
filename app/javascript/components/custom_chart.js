function renderCharts() {
  // Clean up existing charts to prevent memory leaks
  document.querySelectorAll(".chart-canvas").forEach(canvas => {
    const existingChart = Chart.getChart(canvas); // Chart.js v3+
    if (existingChart) {
      existingChart.destroy();
    }
  });

  document.querySelectorAll(".chart-canvas").forEach(canvas => {
    let chartData;
    try {
      chartData = JSON.parse(canvas.dataset.chartData || "{}");
    } catch (e) {
      console.error("Invalid JSON data:", e);
      return;
    }

    const labels = Object.keys(chartData);
    const data = Object.values(chartData).map(val => Number(val) || 0);

    if (labels.length === 0 || data.length === 0 || labels.length !== data.length) {
      console.warn("No valid data for chart:", canvas);
      return;
    }

    new Chart(canvas.getContext("2d"), {
      type: "bar",
      data: {
        labels: labels,
        datasets: [{
          label: "Students Counts",
          data: data,
          backgroundColor: "rgba(75, 192, 192, 0.2)",
          borderColor: "rgba(75, 192, 192, 1)",
          borderWidth: 1
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false, // Allows container height to control chart height
        scales: {
          y: {
            beginAtZero: true,
            grid: { color: "#ddd" },
            ticks: { color: "#999" }
          },
          x: {
            grid: { display: false },
            ticks: { color: "#999" }
          }
        },
        plugins: {
          legend: { display: true }
        }
      }
    });
  });
}

// Re-render charts after page load or Turbo/Turbolinks navigation
document.addEventListener("DOMContentLoaded", renderCharts);
document.addEventListener("turbo:load", renderCharts);
document.addEventListener("turbolinks:load", renderCharts);

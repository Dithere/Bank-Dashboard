/**
 * 
 */
function openTab(tabId) {
    const tabs = document.querySelectorAll('.tab-content');
    const buttons = document.querySelectorAll('.tab-btn');
  
    tabs.forEach(tab => tab.style.display = 'none');
    buttons.forEach(btn => btn.classList.remove('active'));
  
    document.getElementById(tabId).style.display = 'block';
    event.target.classList.add('active');
  }
  
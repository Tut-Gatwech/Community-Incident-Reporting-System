// Main JavaScript for Incident Reporting System

document.addEventListener('DOMContentLoaded', function() {
    
    // Initialize tooltips
    var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });
    
    // Initialize popovers
    var popoverTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="popover"]'));
    var popoverList = popoverTriggerList.map(function (popoverTriggerEl) {
        return new bootstrap.Popover(popoverTriggerEl);
    });
    
    // Form validation
    const forms = document.querySelectorAll('.needs-validation');
    Array.from(forms).forEach(form => {
        form.addEventListener('submit', event => {
            if (!form.checkValidity()) {
                event.preventDefault();
                event.stopPropagation();
            }
            form.classList.add('was-validated');
        }, false);
    });
    
    // Password strength checker
    const passwordInput = document.getElementById('password');
    if (passwordInput) {
        passwordInput.addEventListener('input', function() {
            checkPasswordStrength(this.value);
        });
    }
    
    // Confirm password checker
    const confirmPasswordInput = document.getElementById('confirmPassword');
    if (confirmPasswordInput && passwordInput) {
        confirmPasswordInput.addEventListener('input', function() {
            checkPasswordMatch(passwordInput.value, this.value);
        });
    }
    
    // Auto-refresh notifications every 60 seconds
    setInterval(refreshNotifications, 60000);
    
    // Initialize date pickers
    const dateInputs = document.querySelectorAll('input[type="date"]');
    dateInputs.forEach(input => {
        if (!input.value) {
            input.valueAsDate = new Date();
        }
    });
    
    // Table row click handler
    const tableRows = document.querySelectorAll('table.table-hover tbody tr[data-href]');
    tableRows.forEach(row => {
        row.style.cursor = 'pointer';
        row.addEventListener('click', function() {
            window.location.href = this.dataset.href;
        });
    });
    
    // Modal handlers
    const deleteButtons = document.querySelectorAll('.btn-delete');
    deleteButtons.forEach(button => {
        button.addEventListener('click', function(e) {
            e.stopPropagation();
            const itemId = this.dataset.id;
            const itemName = this.dataset.name;
            const modal = document.getElementById('deleteModal');
            if (modal) {
                modal.querySelector('#deleteItemId').value = itemId;
                modal.querySelector('#deleteItemName').textContent = itemName;
            }
        });
    });
    
    // Search functionality
    const searchInput = document.getElementById('searchInput');
    if (searchInput) {
        searchInput.addEventListener('keyup', function(e) {
            if (e.key === 'Enter') {
                performSearch(this.value);
            }
        });
    }
    
    // Load more functionality for pagination
    const loadMoreBtn = document.getElementById('loadMoreBtn');
    if (loadMoreBtn) {
        loadMoreBtn.addEventListener('click', function() {
            loadMoreItems();
        });
    }
});

// Function to check password strength
function checkPasswordStrength(password) {
    const strengthBar = document.getElementById('passwordStrength');
    if (!strengthBar) return;
    
    let strength = 0;
    if (password.length >= 8) strength++;
    if (/[A-Z]/.test(password)) strength++;
    if (/[a-z]/.test(password)) strength++;
    if (/[0-9]/.test(password)) strength++;
    if (/[^A-Za-z0-9]/.test(password)) strength++;
    
    const strengthText = ['Very Weak', 'Weak', 'Fair', 'Good', 'Strong'];
    const strengthColors = ['danger', 'danger', 'warning', 'info', 'success'];
    
    strengthBar.style.width = (strength * 20) + '%';
    strengthBar.className = 'progress-bar bg-' + strengthColors[strength - 1] || 'danger';
    strengthBar.textContent = strengthText[strength - 1] || 'Very Weak';
}

// Function to check password match
function checkPasswordMatch(password, confirmPassword) {
    const matchText = document.getElementById('passwordMatch');
    if (!matchText) return;
    
    if (password === confirmPassword) {
        matchText.textContent = 'Passwords match';
        matchText.className = 'text-success small';
    } else {
        matchText.textContent = 'Passwords do not match';
        matchText.className = 'text-danger small';
    }
}

// Function to refresh notifications
function refreshNotifications() {
    const notificationCount = document.querySelector('.notification-count');
    if (notificationCount) {
        fetch('/api/notifications/count')
            .then(response => response.json())
            .then(data => {
                if (data.count > 0) {
                    notificationCount.textContent = data.count;
                    notificationCount.classList.remove('d-none');
                } else {
                    notificationCount.classList.add('d-none');
                }
            });
    }
}

// Function to perform search
function performSearch(query) {
    if (query.trim() === '') return;
    
    const searchForm = document.getElementById('searchForm');
    if (searchForm) {
        searchForm.querySelector('input[name="keyword"]').value = query;
        searchForm.submit();
    } else {
        window.location.href = 'search.jsp?q=' + encodeURIComponent(query);
    }
}

// Function to load more items (pagination)
function loadMoreItems() {
    const loadMoreBtn = document.getElementById('loadMoreBtn');
    const currentPage = parseInt(loadMoreBtn.dataset.page) || 1;
    const nextPage = currentPage + 1;
    
    fetch(/api/items?page=)
        .then(response => response.json())
        .then(data => {
            if (data.items.length > 0) {
                appendItems(data.items);
                loadMoreBtn.dataset.page = nextPage;
            } else {
                loadMoreBtn.disabled = true;
                loadMoreBtn.textContent = 'No more items';
            }
        });
}

// Function to append items to list
function appendItems(items) {
    const itemsContainer = document.getElementById('itemsContainer');
    items.forEach(item => {
        const itemElement = createItemElement(item);
        itemsContainer.appendChild(itemElement);
    });
}

// Function to create item element (template)
function createItemElement(item) {
    const div = document.createElement('div');
    div.className = 'item';
    div.innerHTML = 
        <h5></h5>
        <p></p>
    ;
    return div;
}

// Function to show loading spinner
function showLoading(containerId) {
    const container = document.getElementById(containerId);
    if (container) {
        const spinner = document.createElement('div');
        spinner.className = 'spinner';
        spinner.style.margin = '20px auto';
        container.innerHTML = '';
        container.appendChild(spinner);
    }
}

// Function to show alert
function showAlert(message, type = 'info') {
    const alertDiv = document.createElement('div');
    alertDiv.className = lert alert- alert-dismissible fade show;
    alertDiv.innerHTML = 
        
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    ;
    
    const container = document.querySelector('.alert-container') || document.body;
    container.prepend(alertDiv);
    
    // Auto remove after 5 seconds
    setTimeout(() => {
        alertDiv.remove();
    }, 5000);
}

// Export functions for use in other scripts
window.IRS = {
    showAlert: showAlert,
    showLoading: showLoading,
    checkPasswordStrength: checkPasswordStrength,
    checkPasswordMatch: checkPasswordMatch
};

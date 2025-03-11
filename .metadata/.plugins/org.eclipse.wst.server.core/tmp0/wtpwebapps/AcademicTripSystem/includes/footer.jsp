<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<footer>
    <div class="footer-content">
        <p>&copy; 2023 Academic Trip System. All rights reserved.</p>
        <p class="mt-2 text-sm text-gray-300">Empowering Educational Journeys</p>
    </div>
</footer>

<!-- Add to bottom of page to prevent FOUC (Flash of Unstyled Content) -->
<script>
    // Apply any custom theme preferences if stored
    document.addEventListener('DOMContentLoaded', function() {
        // Check for any stored theme preferences and apply them
        const theme = localStorage.getItem('ats-theme');
        if (theme === 'dark') {
            // Add dark mode classes if we implement dark mode in the future
        }
    });
</script>

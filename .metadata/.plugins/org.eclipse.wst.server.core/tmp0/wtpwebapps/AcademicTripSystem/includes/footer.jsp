<%-- Remove or comment out the page directive that specifies contentType --%>
<%-- <%@ page contentType="text/html;charset=UTF-8" %> --%>

<footer class="bg-indigo-900 text-white mt-auto py-6">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="md:flex md:items-center md:justify-between">
            <div class="flex justify-center md:order-2 space-x-6">
                <a href="#" class="text-gray-300 hover:text-white">
                    <span class="sr-only">Help Center</span>
                    <i class="fas fa-question-circle text-xl"></i>
                </a>
                <a href="#" class="text-gray-300 hover:text-white">
                    <span class="sr-only">Contact Support</span>
                    <i class="fas fa-headset text-xl"></i>
                </a>
                <a href="#" class="text-gray-300 hover:text-white">
                    <span class="sr-only">Privacy Policy</span>
                    <i class="fas fa-shield-alt text-xl"></i>
                </a>
            </div>
            <div class="mt-8 md:mt-0 md:order-1 text-center md:text-left">
                <p class="text-base text-gray-300">&copy; <%= java.time.Year.now().getValue() %> Academic Trip System. All rights reserved.</p>
                <p class="text-sm text-gray-400 mt-1">Version 1.0.0</p>
            </div>
        </div>
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

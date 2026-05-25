// Go to previous page.
if (--current_page < 0) {
    // Wrap around.
    current_page = array_length(easing_pages) - 1;
}

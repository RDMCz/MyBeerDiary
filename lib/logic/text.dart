String truncate(String text, int maxChars) =>
    text.length <= maxChars ? text : "${text.substring(0, maxChars)}...";

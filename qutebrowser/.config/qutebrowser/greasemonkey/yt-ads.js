// ==UserScript==
// @name         Auto Skip YouTube Ads (Improved)
// @version      1.2.0
// @description  Automatically skip YouTube ads
// @match        *://*.youtube.com/*
// ==/UserScript==

(function() {
    'use strict';

    setInterval(() => {
        // Try to click skip button
        const skipBtn = document.querySelector('.ytp-ad-skip-button, .ytp-ad-skip-button-container');
        if (skipBtn) {
            skipBtn.click();
        }

        // If an ad is playing, jump to end
        const video = document.querySelector('video');
        if (video && video.duration > 0 && document.querySelector('.ad-showing')) {
            video.currentTime = video.duration;
        }
    }, 1000); // check every second
})();


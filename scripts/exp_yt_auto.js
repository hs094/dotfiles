import { PlaywrightCrawler } from 'crawlee';

async function hasGoogleSession(page) {
    const cookies = await page.context().cookies([
        'https://www.youtube.com',
        'https://accounts.google.com',
    ]);

    return cookies.some(cookie =>
        ['SID', 'HSID', 'SSID', 'APISID', 'SAPISID'].includes(cookie.name)
    );
}


const crawler = new PlaywrightCrawler({
    launchContext: {
        userDataDir: './youtube-session',
        launchOptions: {
            headless: false,
        },
    },

    async requestHandler({ page, request, log }) {
        log.info(`Opening ${request.url}`);

        await page.goto('https://www.youtube.com/', {
            waitUntil: 'domcontentloaded',
        });

        // Check whether this persistent profile is already authenticated.
        const loggedIn = await hasGoogleSession(page);

        if (!loggedIn) {
            log.info('🔐 No authenticated YouTube session found.');
            log.info('⏳ Please log in to Google...');

            // Wait indefinitely for the user to finish login.
            await page.waitForFunction(
                () => Boolean(
                    document.querySelector(
                        'button#avatar-btn, ytd-topbar-menu-button-renderer #avatar-btn'
                    )
                ),
                { timeout: 0 }
            );

            log.info('✅ YouTube login completed.');

            // Allow cookies/session state to settle.
            await page.waitForTimeout(2000);
        } else {
            log.info('✅ Existing YouTube session found.');
        }

        // ------------------------------------------------
        // Your actual browser automation starts here.
        // ------------------------------------------------

        log.info('🚀 Starting YouTube automation...');

        // Example:
        // await page.goto('https://www.youtube.com/...');
        // await page.locator(...).click();
        // ...
    },
});

try {
    await crawler.run([
        {
            url: 'https://www.youtube.com/',
        },
    ]);
} finally {
    await crawler.teardown();
    console.log('👋 Done.');
    process.exit(0);
}

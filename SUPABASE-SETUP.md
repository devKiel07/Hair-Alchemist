# Connect the owner dashboard

The dashboard is part of `The Hair Alchemist.html`. Supabase provides the owner sign-in, product database, and image storage. Keep `supabase-setup.sql`, `supabase-config.js`, and the `Assets` folder alongside the HTML file when publishing the site.

## Create and configure the Supabase project

1. Create a Supabase project on the free plan.
2. In the project, open **SQL Editor**, paste the contents of `supabase-setup.sql`, and run it. This creates the public product catalogue, seeds the current products and prices, and restricts product and image changes to `benedictabrenyah8@gmail.com`.
3. In **Project Settings → API**, copy the **Project URL** and the public **anon** or **publishable** key. Put them in `supabase-config.js`:

   ```js
   export const SUPABASE_URL = 'https://YOUR_PROJECT.supabase.co';
   export const SUPABASE_ANON_KEY = 'YOUR_PUBLIC_ANON_OR_PUBLISHABLE_KEY';
   ```

   A public anon/publishable key is intended for browser use. Never put a service-role key or database password in this file.

4. In **Authentication → Users**, create the owner account with email `benedictabrenyah8@gmail.com` and set a strong, unique password privately. Do not use the email address as the password. Disable public sign-ups in **Authentication → Providers → Email** after creating the account.
5. In **Authentication → URL Configuration**, set the site URL to the deployed website and add the exact page URL to the allowed redirect URLs, for example `https://YOUR_ACCOUNT.github.io/YOUR_REPOSITORY/The%20Hair%20Alchemist.html`.
6. Publish the HTML file, `supabase-config.js`, and the complete `Assets` folder at the paths referenced by the page.
7. Open the website and select the account icon in the navigation bar. Enter the owner password to access the dashboard and add products or edit product names, categories, prices, and photos.

The owner dashboard requires an `https://` website (such as GitHub Pages); opening the HTML directly as a `file://` page does not support the secure sign-in flow. Passwords are checked by Supabase Auth and are never stored in the website code. The email address is fixed to the owner account, and database/storage policies independently enforce the same owner restriction.

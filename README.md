# Project 4 

# Name

Andy Dinh 

# Project description 
Building my own personal blog where I share my experience with triathlons. 

# Features 
Requirements: 10 points

General: 5 points

  - (+1): Includes at least two meaningful routes/pages (home / and blog /blog pages)
  - (+4): Includes multiple meaningful and self-contained Svelte components (Header, Footer, Contacts, and Post components)

  Svelte features: 13 points

  - (+2): Uses basic interpolation to render script variables throughout all components (e.g., {title}, {content},
  {currentLike})
  - (+2): Uses the $state() rune to make script variables reactive in Post.svelte (currentLike, hasLiked, initialized)
  - (+2): Uses the $props() rune to pass data from parent to child in Post.svelte and blog page
  - (+2): Uses TypeScript for all
  - (+2): Includes a Svelte-style event handler directive with onclick={handleLike} in Post.svelte
  - (+3): Includes advanced interpolation with {#if}, {:else if}, {:else} blocks in blog page for conditional rendering of
  Strava stats

  SvelteKit features: 5 points

  - (+2): Uses at least one +layout.svelte component to handle shared UI elements (Header and Footer) between pages
  - (+3): Uses a +page.server.ts script to pass custom data (Strava stats) to the blog page

  Advanced: 4 points

  - (+4): Is deployed to GitHub pages using adapter-static with proper configuration
  https://andydinh2703.github.io/Projects/

# Sources
- [MDN: Web Storage API](https://developer.mozilla.org/en-US/docs/Web/API/Web_Storage_API)
- [Svelte 5 Docs: $effect](https://svelte-5-preview.vercel.app/docs/runes#$effect)
- [SvelteKit Docs: browser](https://kit.svelte.dev/docs/modules#$app-environment-browser)
- [BuildingBlog](https://joshcollinsworth.com/blog/build-static-sveltekit-markdown-blog)

**GitHub Pages Documentation**
   - https://docs.github.com/en/pages/getting-started-with-github-pages
   - Official GitHub Pages setup and configuration guide

**GitHub Actions for Pages**
   - https://github.com/actions/deploy-pages
   - Official GitHub Action for deploying to GitHub Pages

**SvelteKit Path Configuration**
   - https://kit.svelte.dev/docs/configuration#paths
   - Documentation for configuring base paths in SvelteKit

**LLM prompts**
    - "I would like to deploy this project through Github. How would I do that? Please provide guidance step by step exlaining to help me learn to do it instead of just giving me code." 
    - "I'm having problem with implementing localStorage as it needs to be reactive as well. Does Svelte have any unique way to solve it? If so, provide guidance with explaination of how things interact with each other and help me learn to do it next time."

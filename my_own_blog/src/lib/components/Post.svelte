<!-- post -->
 <script lang="ts">
    import { browser } from "$app/environment";

    // creating structure of the post
    interface Post {
        title: string;
        imageUrl: string;
        content: string;
        date: string;
        interaction: number;
        postID: string;
    }

    let {
        title,
        imageUrl,
        content,
        date,
        interaction,
        postID
    }: Post = $props();

    // unique keys for each post
    const like_count_key = `blog:post:${postID}:likes`;
    const has_liked_key = `blog:post:${postID}:hasLiked`;

    let currentLike = $state(0);
    let hasLiked = $state(false);
    let initialized = $state(false);

    // Effect 1: Load saved values from localStorage
    $effect(() => {
        if (browser && !initialized) {
            const storedLikes = localStorage.getItem(like_count_key);
            const storedHasLiked = localStorage.getItem(has_liked_key);

            if (storedLikes !== null) {
                const parsed = Number(storedLikes);
                // Only update if it's a valid number
                if (!isNaN(parsed)) {
                    currentLike = parsed;
                }
            }

            if (storedHasLiked !== null) {
                hasLiked = storedHasLiked === 'true';
            }

            // Mark as initialized 
            initialized = true;
        }
    });

    // Effect 2: Save to localStorage whenever values change 
    $effect(() => {
        if (browser && initialized) {
            localStorage.setItem(like_count_key, String(currentLike));
            localStorage.setItem(has_liked_key, String(hasLiked));
        }
    });

    function handleLike() {
        if (!hasLiked) {
            currentLike++;
            hasLiked = true;
        }
        else {
            currentLike--;
            hasLiked = false;
        }
    }
 </script>

 <article class="post_container">
    <div class="post_pic">
        <h3>{title}</h3>
        <img src={imageUrl} alt="" class= "post-image">

    </div>

    <div class= "post_content">
        <h3>Date: {date}</h3>
        <p>{content}</p>

        <button onclick={handleLike} class="like_button">👍 {currentLike}</button>
    </div>

 </article>


<!-- blog/+page.svelte -->
 <script lang="ts">
   import Post from "$lib/components/Post.svelte";
   import genevaHalf from '$lib/assets/geneva_half.png';
   import myBike from '$lib/assets/my_bike.jpg';
   import type { PageData } from "../$types";
   import { error } from "@sveltejs/kit";

   let {data}: {data: PageData} = $props();

   const meter_to_mile = 0.00062137;

   function mile(meters: number) {
      return (meters * meter_to_mile).toFixed(1);
   }
 </script>

{#if data.stats }
   <!-- // -- stat box -- -->
   <div class = "stat_box">
    <p id="distance">🏃 Running Distance: {mile(data.stats.all_run_totals.distance)} mi </p>
    <p id="streak">🚴 Cycling Distance: {mile(data.stats.all_ride_totals.distance)} mi </p>
    <p id="activities">🔥 Total activities: {data.stats.all_run_totals.count + data.stats.all_ride_totals.count} </p>
 </div>

{:else if data.error }
   <p>Fail to load stats: {data.error}</p>

{:else }
   <p>Loading ...</p>

{/if}




 <Post title="Go One More"
         imageUrl={genevaHalf}
         date="08/10/2025"
         content ="I committed the whole summer for the Geneva Half Marathon. 
         Consistently waking up at 4:30am every day to run, I love every single one I finished the race in
         1:58:57 which wasn't what I aimed for, but I left everything out there."
         interaction = {0}
         postID = "post_1"
   />

<Post title="Get a bike!"
         imageUrl={myBike}
         date="09/28/2025"
         content ="I would never thought about having a bike at all, and I regret not having it earlier.
                     Riding a bike is just a different feeling. It's about freedom to be where I've never
                     been and met people whom I've never met."
         interaction = {0}
         postID = "post2"
/>


 
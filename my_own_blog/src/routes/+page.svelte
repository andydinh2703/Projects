<script>
    import '$lib/styles/style.css'
    import Contacts from '$lib/components/Contacts.svelte';
    import myPic from '$lib/assets/my_pic.png';
    import genevaHalf from '$lib/assets/geneva_half.png';
    import runPic from '$lib/assets/run.png';
    import swimPic from '$lib/assets/swim.png';
    import bikePic from '$lib/assets/bike.png';
</script>

<div class = "my_info">
    <div class = "intro">
        <h1 id = "my_name">Hi, I'm Andy.</h1>

        <p id = "intro_p">I'm a Junior majoring in Computer Science at Hobart & William Smith.
        When I'm out of classrooms, I love spending time training. I've recently 
        fallen in love with Triathlon which keeps me active mentally and physically.
        Welcome to my blog!</p>
    </div>

    <img src={myPic} alt="profile picture" id = "my_pic">
</div>

<hr class = "divider">

<div class = "pictures_bar">

    <img src={genevaHalf} alt="Geneva Half Marathon" class="pictures" id = "pic1">
    <img src={runPic} alt="Running training" class="pictures" id = "pic2">
    <img src={swimPic} alt="Swimming training" class="pictures" id = "pic3">
    <img src={bikePic} alt="Cycling training" class="pictures" id = "pic4">

</div>

<Contacts />
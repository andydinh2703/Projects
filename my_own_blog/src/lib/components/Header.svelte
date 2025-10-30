<!-- Header for the page -->
<script>
    import '$lib/styles/style.css';
    import logo from '$lib/assets/logo.png';
    import { base } from '$app/paths';
</script>

<header>
    <!-- blog logo -->
    <img src={logo} alt="GO GET YOURS">

    <nav>
        <a href="{base}/">Home</a>
        <a href="{base}/blog">Blog</a>
    </nav>

</header>

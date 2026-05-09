<script setup>
import { useData } from "vitepress";
import DefaultTheme from "vitepress/theme";
import MarketingLayout from "./components/MarketingLayout.vue";

const { frontmatter } = useData();
const DefaultLayout = DefaultTheme.Layout;
</script>

<template>
  <MarketingLayout v-if="frontmatter.layout === 'marketing'" />
  <DefaultLayout v-else />
</template>

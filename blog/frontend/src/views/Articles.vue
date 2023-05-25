<template>
  <div>
    <h1 class="mb-4">Articles</h1>
    <h2 class="mb-4">Our blog has <span class="badge bg-primary">{{ articleCount }}</span> articles and counting!</h2>
    <ul class="list-group mb-4">
      <li v-for="article in articles" :key="article.id" class="list-group-item">
        <router-link :to="`/articles/${article.id}`">{{ article.title }}</router-link>
      </li>
    </ul>
    <paginate :page-count="pageCount" :click-handler="fetchArticles" container-class="pagination justify-content-center"></paginate>
    <SignComponent />
  </div>
</template>

<script>
import SignComponent from '@/components/shared/SignComponent.vue';

export default {
  components: {
    SignComponent,
  },
  data() {
    return {
      articles: [],
      articleCount: 0,
      pageCount: 0,
      currentPage: 1,
    };
  },
  mounted() {
    this.fetchArticles();
  },
  methods: {
    fetchArticles() {
      // Make an API request to fetch the articles
      // Update the articles, articleCount, pageCount, and currentPage data properties accordingly
    },
  },
};
</script>

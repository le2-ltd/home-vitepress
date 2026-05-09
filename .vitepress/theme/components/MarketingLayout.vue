<script setup>
import { computed, ref } from "vue";
import { useData, useRoute, withBase } from "vitepress";
import { navigationItems, siteContent } from "../data/siteContent";

const { frontmatter } = useData();
const route = useRoute();

const pageType = computed(() => frontmatter.value.pageType || "home");
const page = computed(() => siteContent[pageType.value] || siteContent.home);
const contact = computed(() => siteContent.contact || {});
const year = new Date().getFullYear();
const selectedCaseCategory = ref("全部");

const caseCategories = computed(() => {
  if (pageType.value !== "cases") return [];
  return ["全部", ...new Set((page.value.cases || []).map((item) => item.category).filter(Boolean))];
});

const filteredCases = computed(() => {
  if (pageType.value !== "cases") return [];
  if (selectedCaseCategory.value === "全部") return page.value.cases || [];
  return (page.value.cases || []).filter((item) => item.category === selectedCaseCategory.value);
});

function localHref(href) {
  if (href.startsWith("#")) return href;
  if (href.startsWith("http")) return href;
  return withBase(href);
}

function isActive(href) {
  const current = route.path.replace(/\.html$/, "").replace(/\/$/, "") || "/";
  const target = href.replace(/\/$/, "") || "/";
  return current === target;
}
</script>

<template>
  <div class="mk-shell" :class="`mk-shell--${pageType}`">
    <header class="mk-header">
      <a class="mk-brand" :href="localHref('/')" aria-label="成都雷耳兔科技有限公司首页">
        <span class="mk-brand__name">成都雷耳兔科技有限公司</span>
        <span class="mk-brand__meta">Le2.ltd</span>
      </a>
      <nav class="mk-nav" aria-label="主导航">
        <a
          v-for="item in navigationItems"
          :key="item.href"
          class="mk-nav__link"
          :class="{ 'is-active': isActive(item.href) }"
          :href="localHref(item.href)"
        >
          {{ item.label }}
        </a>
      </nav>
      <a class="mk-header__contact" href="#contact">联系团队</a>
    </header>

    <main class="mk-main">
      <section class="mk-hero" :class="`mk-hero--${pageType}`">
        <div class="mk-hero__copy">
          <p class="mk-eyebrow">{{ page.eyebrow }}</p>
          <h1>
            <span v-for="line in page.titleLines || [page.title]" :key="line">{{ line }}</span>
          </h1>
          <p class="mk-lead">{{ page.lead }}</p>
          <p v-if="page.scopeLine" class="mk-scope-line">{{ page.scopeLine }}</p>
          <div v-if="pageType === 'home'" class="mk-actions">
            <a
              v-for="action in page.actions"
              :key="action.href"
              class="mk-button"
              :class="`mk-button--${action.variant || 'ghost'}`"
              :href="localHref(action.href)"
            >
              {{ action.label }}
            </a>
          </div>
        </div>

        <div v-if="pageType === 'home'" class="mk-hero-panel" aria-label="业务与交付指标">
          <div v-for="metric in page.metrics" :key="metric.label" class="mk-metric">
            <strong>{{ metric.value }}</strong>
            <span>{{ metric.label }}</span>
            <p>{{ metric.detail }}</p>
          </div>
        </div>
      </section>

      <template v-if="pageType === 'home'">
        <section class="mk-section mk-section--grid">
          <div class="mk-section__intro">
            <p class="mk-eyebrow">Engineering focus</p>
            <h2>以可审计、可复盘、可协作的方式交付系统</h2>
          </div>
          <div class="mk-tile-grid mk-tile-grid--four">
            <article v-for="(pillar, index) in page.pillars" :key="pillar.title" class="mk-tile">
              <span class="mk-tile__index">0{{ index + 1 }}</span>
              <h3>{{ pillar.title }}</h3>
              <p>{{ pillar.text }}</p>
            </article>
          </div>
        </section>

        <section class="mk-section mk-section--product">
          <div class="mk-section__intro mk-section__intro--wide">
            <p class="mk-eyebrow">Domestic product systems</p>
            <h2>面向国内业务场景，建设可持续演进的产品与系统</h2>
          </div>
          <div class="mk-product-grid">
            <article
              v-for="(system, index) in page.productSystems"
              :key="system.title"
              class="mk-product-card"
            >
              <span class="mk-tile__index">0{{ index + 1 }}</span>
              <h3>{{ system.title }}</h3>
              <p>{{ system.text }}</p>
            </article>
          </div>
        </section>

        <section class="mk-band">
          <div class="mk-band__copy">
            <p class="mk-eyebrow">Operating model</p>
            <h2>产品建设、项目交付、长期运营</h2>
          </div>
          <ul class="mk-checklist">
            <li v-for="item in page.operatingModel" :key="item">{{ item }}</li>
          </ul>
        </section>

        <section class="mk-section">
          <div class="mk-section__intro mk-section__intro--wide">
            <p class="mk-eyebrow">How we start</p>
            <h2>合作起步方式清晰，便于尽快进入有效沟通</h2>
          </div>
          <div class="mk-tile-grid mk-tile-grid--four">
            <article v-for="(step, index) in page.collaborationSteps" :key="step.title" class="mk-tile">
              <span class="mk-tile__index">0{{ index + 1 }}</span>
              <h3>{{ step.title }}</h3>
              <p>{{ step.text }}</p>
            </article>
          </div>
        </section>

        <section class="mk-section">
          <div class="mk-section__intro mk-section__intro--wide">
            <p class="mk-eyebrow">Case signals</p>
            <h2>从行业系统里沉淀工程判断</h2>
          </div>
          <div class="mk-case-strip">
            <article v-for="item in page.caseHighlights" :key="item.title" class="mk-case-card">
              <span>{{ item.tag }}</span>
              <h3>{{ item.title }}</h3>
              <p>{{ item.text }}</p>
            </article>
          </div>
        </section>
      </template>

      <template v-else-if="pageType === 'skills'">
        <section class="mk-section">
          <div class="mk-skill-grid">
            <article v-for="group in page.groups" :key="group.title" class="mk-skill-card">
              <div>
                <p class="mk-eyebrow">Capability</p>
                <h2>{{ group.title }}</h2>
                <p>{{ group.text }}</p>
              </div>
              <ul class="mk-tags">
                <li v-for="item in group.items" :key="item">{{ item }}</li>
              </ul>
            </article>
          </div>
        </section>
      </template>

      <template v-else-if="pageType === 'engineering'">
        <section class="mk-section mk-section--flush">
          <div class="mk-process">
            <div class="mk-process__head">
              <p class="mk-eyebrow">Lifecycle controls</p>
              <h2>阶段与流程的责任矩阵</h2>
            </div>
            <div class="mk-table-wrap">
              <table class="mk-process-table">
                <thead>
                  <tr>
                    <th scope="col">流程 / 阶段</th>
                    <th v-for="column in page.processColumns" :key="column" scope="col">{{ column }}</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="row in page.processRows" :key="row.name">
                    <th scope="row">{{ row.name }}</th>
                    <td v-for="cell in row.cells" :key="cell">{{ cell }}</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </section>

        <section class="mk-section">
          <div class="mk-tile-grid mk-tile-grid--two">
            <article v-for="section in page.sections" :key="section.title" class="mk-tile mk-tile--large">
              <h2>{{ section.title }}</h2>
              <p>{{ section.text }}</p>
            </article>
          </div>
        </section>
      </template>

      <template v-else-if="pageType === 'cases'">
        <section class="mk-section">
          <div class="mk-case-filters">
            <button
              v-for="category in caseCategories"
              :key="category"
              class="mk-filter-button"
              :class="{ 'is-active': selectedCaseCategory === category }"
              type="button"
              @click="selectedCaseCategory = category"
            >
              {{ category }}
            </button>
          </div>
          <div class="mk-case-list">
            <article v-for="item in filteredCases" :key="item.title" class="mk-case-study">
              <div class="mk-case-study__summary">
                <p class="mk-eyebrow">{{ item.industry }}</p>
                <h2>{{ item.title }}</h2>
                <dl class="mk-case-meta">
                  <div>
                    <dt>交付节奏</dt>
                    <dd>{{ item.cadence }}</dd>
                  </div>
                  <div>
                    <dt>项目角色</dt>
                    <dd>{{ item.roles.join(" / ") }}</dd>
                  </div>
                </dl>
                <ul class="mk-tags">
                  <li v-for="tag in item.tags" :key="tag">{{ tag }}</li>
                </ul>
              </div>
              <div class="mk-case-study__body">
                <section>
                  <h3>问题</h3>
                  <p>{{ item.challenge }}</p>
                </section>
                <section>
                  <h3>方案</h3>
                  <p>{{ item.solution }}</p>
                </section>
                <section>
                  <h3>难点拆解</h3>
                  <ul class="mk-case-points">
                    <li v-for="point in item.difficulties" :key="point">{{ point }}</li>
                  </ul>
                </section>
                <section>
                  <h3>结果</h3>
                  <p>{{ item.result }}</p>
                </section>
              </div>
            </article>
          </div>
        </section>
      </template>

      <section id="contact" class="mk-cta">
        <div>
          <p class="mk-eyebrow">{{ contact.eyebrow }}</p>
          <h2>{{ contact.title }}</h2>
          <p class="mk-cta__label">{{ contact.topicsLabel }}</p>
          <ul class="mk-cta__topics">
            <li v-for="topic in contact.topics" :key="topic">{{ topic }}</li>
          </ul>
        </div>
        <figure class="mk-contact-card">
          <img :src="localHref('/contact-qr.png')" alt="成都雷耳兔科技有限公司微信联系二维码" />
          <figcaption>微信扫码联系</figcaption>
        </figure>
      </section>
    </main>

    <footer class="mk-footer">
      <div>
        <strong>成都雷耳兔科技有限公司</strong>
        <p>Copyright © 2021-{{ year }} Le2.ltd 版权所有</p>
      </div>
      <div class="mk-footer__links">
        <a href="http://beian.miit.gov.cn" target="_blank" rel="noreferrer">蜀ICP备2024116916号-1</a>
        <a href="http://beian.miit.gov.cn" target="_blank" rel="noreferrer">蜀ICP备2024116916号-2</a>
        <a href="http://beian.miit.gov.cn" target="_blank" rel="noreferrer">蜀ICP备2024116916号-3</a>
      </div>
    </footer>
  </div>
</template>

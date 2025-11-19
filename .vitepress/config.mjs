import { defineConfig } from "vitepress";

import { MermaidMarkdown, MermaidPlugin } from "vitepress-plugin-mermaid";

// https://vitepress.dev/reference/site-config
export default defineConfig({
  rewrites: {
    // 左边：真实存在的文件路径（相对 srcDir）
    // 右边：希望它在站点中对应的“虚拟路径”
    "aboutus.md": "index.md",
  },
  // head: [["link", { rel: "icon", href: "/favicon.ico" }]],
  markdown: {
    config(md) {
      md.use(MermaidMarkdown);
    },
  },
  srcDir: "docs",
  title: "成都雷耳兔科技有限公司",
  description: "",
  themeConfig: {
    // search: {
    //   provider: "local",
    // },
    outline: {
      label: "页面导航",
    },
    lastUpdated: {
      text: "最后更新",
      formatOptions: {
        dateStyle: "full",
        timeStyle: "medium",
      },
    },
    // https://vitepress.dev/reference/default-theme-config
    // nav: [
    //   { text: "首页", link: "/" },
    //   { text: "演示站点", link: "https://h5-demo.rc1.le2.ltd/" },
    // ],

    // sidebar: [
    //   {
    //     text: "Examples",
    //     items: [
    //       { text: "Markdown Examples", link: "/markdown-examples" },
    //       { text: "Runtime API Examples", link: "/api-examples" },
    //     ],
    //   },
    // ],
    // nav: [
    //   { text: "首页", link: "/" },
    //   { text: "GitHub", link: "https://github.com/your-repo" },
    // ],
    sidebar: [
      {
        // text: "总体介绍",
        collapsible: false,
        items: [
          {
            text: "关于我们",
            link: "/index",
          },
          {
            text: "技能能力",
            link: "/skills",
          },
          {
            text: "工程能力",
            link: "/engineering.md",
          },
          {
            text: "案例",
            link: "/cases.md",
          },
        ],
      },
    ],

    // socialLinks: [
    //   { icon: "github", link: "https://github.com/vuejs/vitepress" },
    // ],

    footer: {
      message:
        '<a href="http://beian.miit.gov.cn" target="_blank">蜀ICP备2024116916号-1</a>',
      // 动态年份
      copyright: `Copyright © 2021-${new Date().getFullYear()} Le2.ltd 版权所有`,
    },
  },

  mermaid: {
    // refer https://mermaid.js.org/config/setup/modules/mermaidAPI.html#mermaidapi-configuration-defaults for options
  },
  // optionally set additional config for plugin itself with MermaidPluginConfig
  mermaidPlugin: {
    class: "mermaid my-class", // set additional css classes for parent container
  },

  vite: {
    plugins: [MermaidPlugin()],
    optimizeDeps: {
      include: ["mermaid"], // 只预构建 mermaid
    },
    ssr: {
      noExternal: ["mermaid"],
    },
    server: {
      port: 3000, // 你想要的端口号
      host: "0.0.0.0", // 如果需要对局域网开放，也可以加上 host
    },
  },
});

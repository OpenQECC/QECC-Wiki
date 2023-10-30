/**
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 * @format
 */
// @ts-check
// Note: type annotations allow type checking and IDEs autocompletion

/** @type {import('@docusaurus/types').Config} */
const config = {
  title: 'My Site',
  tagline: 'The tagline of my site',
  favicon: 'img/logo.png',

  // Set the production url of your site here
  url: 'https://openqecc.github.io/',
  // Set the /<baseUrl>/ pathname under which your site is served
  // For GitHub pages deployment, it is often '/<projectName>/'
  baseUrl: '/QECC-Wiki/',

  // GitHub pages deployment config.
  // If you aren't using GitHub pages, you don't need these.
  organizationName: 'OpenQECC', // Usually your GitHub org/user name.
  projectName: 'QECC-Wiki', // Usually your repo name.
  deploymentBranch: 'main',
  onBrokenLinks: 'throw',
  onBrokenMarkdownLinks: 'warn',

  presets: [
    [
      'classic',
      /** @type {import('@docusaurus/preset-classic').Options} */
      ({
        docs: {
          routeBasePath: '/',
          path: 'docs',
          sidebarPath: require.resolve('./sidebars.js'),
          // Please change this to your repo.
          // Remove this to remove the "edit this page" links.
          editUrl:
            'https://github.com/Benzillaist/QECC-Wiki',
        },
        // z  log: {
        //   showReadingTime: true,
        //   // Please change this to your repo.
        //   // Remove this to remove the "edit this page" links.
        //   editUrl:
        //     'https://github.com/Benzillaist/QECC-Wiki',
        // },
        theme: {
          customCss: require.resolve('./src/css/custom.css'),
        },
      }),
    ],
  ],

  themeConfig:
    /** @type {import('@docusaurus/preset-classic').ThemeConfig} */
    ({
      image: 'img/docusaurus-social-card.jpg',
      navbar: {
        title: 'QECC-Wiki',
        logo: {
          alt: 'QECC-Wiki Logo',
          src: 'img/logo.png',
        },
        items: [
          {
            type: 'docSidebar',  // docSidebar
            position: 'left',
            sidebarId: 'api', // foldername
            label: 'Codes',     // navbar title
          },
          {to: 'blog', label: 'Blog', position: 'left'},
          // Please keep GitHub link to the right for consistency.
          {
            href: 'https://github.com/Benzillaist/QECC-Wiki',
            label: 'GitHub',
            position: 'right',
          },
        ],
      },
      footer: {
        style: 'dark',
        links: [
          {
            title: 'Docs',
            items: [
              {
                label: 'Get Started',
                to: '/',
              },
              {
                label: 'Style Guide',
                to: 'welcome/Add%20new%20code/create-a-page',
              },
            ],
          },
          {
            title: 'Community',
            items: [
              {
                label: 'Stack Exchange',
                to: 'https://quantumcomputing.stackexchange.com/',
              },
              {
                label: 'Contributor Covenant',
                to: 'https://www.contributor-covenant.org/version/1/4/code-of-conduct/',
              },
            ],
          },
          {
            title: 'Social',
            items: [
              {
                label: 'GitHub',
                to: 'https://github.com/Benzillaist/QECC-Wiki',
              },
            ],
          }

        ],
        logo: {
          alt: 'QECC Open Source Logo',
          // This default includes a positive & negative version, allowing for
          // appropriate use depending on your site's style.
          src: '/img/qecc-opensource.png',
          href: 'https://opensource.fb.com',
        },
        // Please do not remove the credits, help to publicize Docusaurus :)
        copyright: `Copyright © ${new Date().getFullYear()} Krastanov Lab, University of Massachusetts Amherst.`,
      },
    }),
};

module.exports = config;

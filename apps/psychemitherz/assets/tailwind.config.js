// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration

const plugin = require("tailwindcss/plugin");
const fs = require("fs");
const path = require("path");
const defaultTheme = require("tailwindcss/defaultTheme");

module.exports = {
  content: [
    "./js/**/*.js",
    "../lib/psychemitherz.ex",
    "../lib/psychemitherz/**/*.*ex",
  ],
  purge: {
    options: {
      safelist: ["!bg-creme"],
    },
  },
  theme: {
    extend: {
      colors: {
        brand: "#fd4f00",
        creme: "#f4efec",
        beige: "#fcf8ed",
        champagne: "#f1ddce",
        pink: {
          base: "#EAC9C9",
          light: "#F3DFDF",
        },
        red: {
          50: "#f5eff0",
          100: "#ebe0e0",
          200: "#d4a6ae",
          300: "#c3a1a2",
          400: "#af8283",
          500: "#9b6364",
          600: "#7c4f50",
          700: "#48382d",
          800: "#3e2828",
          900: "#1f1414",
        },
        green: {
          50: "#f7f7f5",
          100: "#eae7d3",
          200: "#dfdfd5",
          300: "#ddd7b7",
          400: "#c0c0ac",
          500: "#b0b097",
          600: "#8d8d79",
          700: "#6a6a5b",
          800: "#46463c",
          900: "#23231e",
        },
        yellow: {
          50: "#fdf9f4",
          100: "#fcf3e9",
          200: "#f8e8d2",
          300: "#f5dcbc",
          400: "#f1d1a5",
          500: "#eec58f",
          600: "#a3836c",
          700: "#8f7656",
          800: "#5f4f39",
          900: "#30271d",
        },
      },
      textColor: "#48382D",
    },
    fontFamily: {
      sans: ["Inter", ...defaultTheme.fontFamily.sans],
      serif: [
        "Merriweather",
        "-apple-system-ui-serif",
        "ui-serif",
        ...defaultTheme.fontFamily.serif,
      ],
      body: ["Inter", ...defaultTheme.fontFamily.sans],
      header: [
        "Merriweather",
        "-apple-system-ui-serif",
        "ui-serif",
        ...defaultTheme.fontFamily.serif,
      ],
    },
    fontSize: {
      sm: "0.9rem",
      base: "1.1rem",
      md: "1.15rem",
      lg: "1.25rem",
      xl: "1.4rem",
      "2xl": "1.563rem",
      "3xl": "1.953rem",
      "4xl": "2.441rem",
      "5xl": "3.052rem",
    },
  },
  plugins: [
    require("@tailwindcss/forms"),
    // Allows prefixing tailwind classes with LiveView classes to add rules
    // only when LiveView classes are applied, for example:
    //
    //     <div class="phx-click-loading:animate-ping">
    //
    plugin(({ addVariant }) =>
      addVariant("phx-no-feedback", [".phx-no-feedback&", ".phx-no-feedback &"])
    ),
    plugin(({ addVariant }) =>
      addVariant("phx-click-loading", [
        ".phx-click-loading&",
        ".phx-click-loading &",
      ])
    ),
    plugin(({ addVariant }) =>
      addVariant("phx-submit-loading", [
        ".phx-submit-loading&",
        ".phx-submit-loading &",
      ])
    ),
    plugin(({ addVariant }) =>
      addVariant("phx-change-loading", [
        ".phx-change-loading&",
        ".phx-change-loading &",
      ])
    ),

    // Embeds Heroicons (https://heroicons.com) into your app.css bundle
    // See your `CoreComponents.icon/1` for more information.
    //
    plugin(function ({ matchComponents, theme }) {
      let iconsDir = path.join(__dirname, "./vendor/heroicons/optimized");
      let values = {};
      let icons = [
        ["", "/24/outline"],
        ["-solid", "/24/solid"],
        ["-mini", "/20/solid"],
      ];
      icons.forEach(([suffix, dir]) => {
        fs.readdirSync(path.join(iconsDir, dir)).map((file) => {
          let name = path.basename(file, ".svg") + suffix;
          values[name] = { name, fullPath: path.join(iconsDir, dir, file) };
        });
      });
      matchComponents(
        {
          hero: ({ name, fullPath }) => {
            let content = fs
              .readFileSync(fullPath)
              .toString()
              .replace(/\r?\n|\r/g, "");
            return {
              [`--hero-${name}`]: `url('data:image/svg+xml;utf8,${content}')`,
              "-webkit-mask": `var(--hero-${name})`,
              mask: `var(--hero-${name})`,
              "mask-repeat": "no-repeat",
              "background-color": "currentColor",
              "vertical-align": "middle",
              display: "inline-block",
              width: theme("spacing.5"),
              height: theme("spacing.5"),
            };
          },
        },
        { values }
      );
    }),

    // https://github.com/desaintflorent/tailwindcss-padding-safe/blob/master/index.js
    plugin(function ({ addUtilities, e, config }) {
      // Paddings
      const paddings = config(
        "theme.paddingSafe.padding",
        config("theme.padding", {})
      );
      const paddingVariants = config(
        "variants.paddingSafe",
        config("variants.padding", {})
      );
      const paddingSuffix = config("theme.paddingSafe.suffix", "safe");
      const paddingOnlySupportsRules = config(
        "theme.paddingSafe.onlySupportsRules",
        false
      );

      const paddingGenerators = [
        (size, modifier) =>
          paddingOnlySupportsRules
            ? null
            : {
                [`.${e(`p-${modifier}-${paddingSuffix}`)}`]: {
                  padding: `${size}`,
                },
              },
        (size, modifier) =>
          paddingOnlySupportsRules
            ? null
            : {
                [`.${e(`py-${modifier}-${paddingSuffix}`)}`]: {
                  "padding-top": `${size}`,
                  "padding-bottom": `${size}`,
                },
                [`.${e(`px-${modifier}-${paddingSuffix}`)}`]: {
                  "padding-left": `${size}`,
                  "padding-right": `${size}`,
                },
              },
        (size, modifier) =>
          paddingOnlySupportsRules
            ? null
            : {
                [`.${e(`pt-${modifier}-${paddingSuffix}`)}`]: {
                  "padding-top": `${size}`,
                },
                [`.${e(`pr-${modifier}-${paddingSuffix}`)}`]: {
                  "padding-right": `${size}`,
                },
                [`.${e(`pb-${modifier}-${paddingSuffix}`)}`]: {
                  "padding-bottom": `${size}`,
                },
                [`.${e(`pl-${modifier}-${paddingSuffix}`)}`]: {
                  "padding-left": `${size}`,
                },
              },
        (size, modifier) => ({
          "@supports(padding: max(0px))": {
            [`.${e(`p-${modifier}-${paddingSuffix}`)}`]: {
              "padding-top": `max(${size}, env(safe-area-inset-top))`,
              "padding-bottom": `max(${size}, env(safe-area-inset-bottom))`,
              "padding-left": `max(${size}, env(safe-area-inset-left))`,
              "padding-right": `max(${size}, env(safe-area-inset-right))`,
            },

            [`.${e(`py-${modifier}-${paddingSuffix}`)}`]: {
              "padding-top": `max(${size}, env(safe-area-inset-top))`,
              "padding-bottom": `max(${size}, env(safe-area-inset-bottom))`,
            },
            [`.${e(`px-${modifier}-${paddingSuffix}`)}`]: {
              "padding-left": `max(${size}, env(safe-area-inset-left))`,
              "padding-right": `max(${size}, env(safe-area-inset-right))`,
            },

            [`.${e(`pt-${modifier}-${paddingSuffix}`)}`]: {
              "padding-top": `max(${size}, env(safe-area-inset-top))`,
            },
            [`.${e(`pr-${modifier}-${paddingSuffix}`)}`]: {
              "padding-right": `max(${size}, env(safe-area-inset-right))`,
            },
            [`.${e(`pb-${modifier}-${paddingSuffix}`)}`]: {
              "padding-bottom": `max(${size}, env(safe-area-inset-bottom))`,
            },
            [`.${e(`pl-${modifier}-${paddingSuffix}`)}`]: {
              "padding-left": `max(${size}, env(safe-area-inset-left))`,
            },
          },
        }),
      ];

      // const paddingUtilities = flatMap(paddingGenerators, (generator) => {
      //   return flatMap(paddings, generator);
      // });
      const paddingUtilities = [].concat(
        ...paddingGenerators.map((generator) => {
          return [].concat(...Object.values(paddings).map(generator));
        })
      );

      addUtilities(paddingUtilities, paddingVariants);

      // Margins
      const margins = config(
        "theme.marginSafe.margin",
        config("theme.margin", {})
      );
      const marginVariants = config(
        "variants.marginSafe",
        config("variants.margin", {})
      );
      const marginSuffix = config("theme.marginSafe.suffix", "safe");
      const marginOnlySupportsRules = config(
        "theme.marginSafe.onlySupportsRules",
        false
      );

      const marginGenerators = [
        (size, modifier) =>
          marginOnlySupportsRules
            ? null
            : {
                [`.${e(`m-${modifier}-${marginSuffix}`)}`]: {
                  margin: `${size}`,
                },
              },
        (size, modifier) =>
          marginOnlySupportsRules
            ? null
            : {
                [`.${e(`my-${modifier}-${marginSuffix}`)}`]: {
                  "margin-top": `${size}`,
                  "margin-bottom": `${size}`,
                },
                [`.${e(`mx-${modifier}-${marginSuffix}`)}`]: {
                  "margin-left": `${size}`,
                  "margin-right": `${size}`,
                },
              },
        (size, modifier) =>
          marginOnlySupportsRules
            ? null
            : {
                [`.${e(`mt-${modifier}-${marginSuffix}`)}`]: {
                  "margin-top": `${size}`,
                },
                [`.${e(`mr-${modifier}-${marginSuffix}`)}`]: {
                  "margin-right": `${size}`,
                },
                [`.${e(`mb-${modifier}-${marginSuffix}`)}`]: {
                  "margin-bottom": `${size}`,
                },
                [`.${e(`ml-${modifier}-${marginSuffix}`)}`]: {
                  "margin-left": `${size}`,
                },
              },
        (size, modifier) => ({
          "@supports(margin: max(0px))": {
            [`.${e(`m-${modifier}-${marginSuffix}`)}`]: {
              "margin-top": `max(${size}, env(safe-area-inset-top))`,
              "margin-bottom": `max(${size}, env(safe-area-inset-bottom))`,
              "margin-left": `max(${size}, env(safe-area-inset-left))`,
              "margin-right": `max(${size}, env(safe-area-inset-right))`,
            },

            [`.${e(`my-${modifier}-${marginSuffix}`)}`]: {
              "margin-top": `max(${size}, env(safe-area-inset-top))`,
              "margin-bottom": `max(${size}, env(safe-area-inset-bottom))`,
            },
            [`.${e(`mx-${modifier}-${marginSuffix}`)}`]: {
              "margin-left": `max(${size}, env(safe-area-inset-left))`,
              "margin-right": `max(${size}, env(safe-area-inset-right))`,
            },

            [`.${e(`mt-${modifier}-${marginSuffix}`)}`]: {
              "margin-top": `max(${size}, env(safe-area-inset-top))`,
            },
            [`.${e(`mr-${modifier}-${marginSuffix}`)}`]: {
              "margin-right": `max(${size}, env(safe-area-inset-right))`,
            },
            [`.${e(`mb-${modifier}-${marginSuffix}`)}`]: {
              "margin-bottom": `max(${size}, env(safe-area-inset-bottom))`,
            },
            [`.${e(`ml-${modifier}-${marginSuffix}`)}`]: {
              "margin-left": `max(${size}, env(safe-area-inset-left))`,
            },
          },
        }),
      ];

      // const marginUtilities = flatMap(marginGenerators, (generator) => {
      //   return flatMap(margins, generator);
      // });
      const marginUtilities = [].concat(
        ...marginGenerators.map((generator) => {
          return [].concat(...Object.values(margins).map(generator));
        })
      );

      addUtilities(marginUtilities, marginVariants);

      // Safe area only classes
      const utilities = [
        {
          ".p-safe": {
            "padding-top": "env(safe-area-inset-top)",
            "padding-bottom": "env(safe-area-inset-bottom)",
            "padding-left": "env(safe-area-inset-left)",
            "padding-right": "env(safe-area-inset-right)",
          },
          ".py-safe": {
            "padding-top": "env(safe-area-inset-top)",
            "padding-bottom": "env(safe-area-inset-bottom)",
          },
          ".px-safe": {
            "padding-left": "env(safe-area-inset-left)",
            "padding-right": "env(safe-area-inset-right)",
          },
          ".pt-safe": { "padding-top": "env(safe-area-inset-top)" },
          ".pr-safe": { "padding-right": "env(safe-area-inset-right)" },
          ".pb-safe": { "padding-bottom": "env(safe-area-inset-bottom)" },
          ".pl-safe": { "padding-left": "env(safe-area-inset-left)" },
        },
        {
          ".m-safe": {
            "margin-top": "env(safe-area-inset-top)",
            "margin-bottom": "env(safe-area-inset-bottom)",
            "margin-left": "env(safe-area-inset-left)",
            "margin-right": "env(safe-area-inset-right)",
          },
          ".my-safe": {
            "margin-top": "env(safe-area-inset-top)",
            "margin-bottom": "env(safe-area-inset-bottom)",
          },
          ".mx-safe": {
            "margin-left": "env(safe-area-inset-left)",
            "margin-right": "env(safe-area-inset-right)",
          },
          ".mt-safe": { "margin-top": "env(safe-area-inset-top)" },
          ".mr-safe": { "margin-right": "env(safe-area-inset-right)" },
          ".mb-safe": { "margin-bottom": "env(safe-area-inset-bottom)" },
          ".ml-safe": { "margin-left": "env(safe-area-inset-left)" },
        },
      ];

      addUtilities(utilities);
    }),
  ],
};

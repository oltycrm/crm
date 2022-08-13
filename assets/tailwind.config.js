// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration

const colors = require("tailwindcss/colors");

let plugin = require("tailwindcss/plugin");

const defaultTheme = require("tailwindcss/defaultTheme");

module.exports = {
  content: [
    "./js/**/*.js",
    "../lib/*_web.ex",
    "../lib/*_web/**/*.*ex",
    "../crm_components/**/*.ex",
    "../../../deps/crm_components/**/*.*ex",
  ],
  purge: [
    "../lib/*_web/**/*.*ex",
    "./js/**/*.js",

    // We need to include the Crm dependency so the classes get picked up by JIT.
    "../../../deps/crm_components/**/*.*ex",
  ],
  theme: {
    extend: {
      colors: {
        primary: colors.blue,
        secondary: colors.orange,
        gray: {
          25: "#fcfcfc",
          ...colors.gray,
        },
        neutral: {
          10: "#fefefe",
          20: "#fdfdfd",
          30: "#fcfcfc",
          40: "#fbfbfb",
        },
      },
      fontFamily: {
        // sans: ["TT Commons", ...defaultTheme.fontFamily.sans],
      },
    },
  },
  plugins: [
    // Scrolbar customization
    require("tailwind-scrollbar"),

    // require('@tailwindcss/forms'),

    require("@tailwindcss/typography"),
    require("@tailwindcss/forms"),
    require("@tailwindcss/line-clamp"),
    require("@tailwindcss/aspect-ratio"),

    plugin(({ addVariant }) =>
      addVariant("phx-no-feedback", ["&.phx-no-feedback", ".phx-no-feedback &"])
    ),
    plugin(({ addVariant }) =>
      addVariant("phx-click-loading", [
        "&.phx-click-loading",
        ".phx-click-loading &",
      ])
    ),
    plugin(({ addVariant }) =>
      addVariant("phx-submit-loading", [
        "&.phx-submit-loading",
        ".phx-submit-loading &",
      ])
    ),
    plugin(({ addVariant }) =>
      addVariant("phx-change-loading", [
        "&.phx-change-loading",
        ".phx-change-loading &",
      ])
    ),
  ],
  // variants: {
  //   scrollbar: ["rounded"],
  // },
  darkMode: "class",
};

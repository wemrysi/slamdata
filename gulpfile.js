"use strict"

var gulp = require("gulp"),
    purescript = require("gulp-purescript"),
    less = require("gulp-less"),
    watch = require("gulp-watch"),
    webpack = require("webpack-stream");

var sources = [
    "src/**/*.purs",
    "bower_components/purescript-*/src/**/*.purs",
    "test/src/**/*.purs"
];

var foreigns = [
    "src/**/*.js",
    "bower_components/purescript-*/src/**/*.js",
    "test/src/**/*.js"
];

gulp.task("make", function() {
    return purescript.psc({
        src: sources,
        ffi: foreigns
    });
});

var bundleTasks = [];

var mkBundleTask = function (name, main) {

    gulp.task("prebundle-" + name, ["make"], function() {
      return purescript.pscBundle({
        src: "output/**/*.js",
        output: "tmp/" + name + ".js",
        module: main,
        main: main
      });
    });

    gulp.task("bundle-" + name, ["prebundle-" + name], function () {
      return gulp.src("tmp/" + name + ".js")
        .pipe(webpack({
          resolve: { modulesDirectories: ["node_modules"] },
          output: { filename: name + ".js" }
        }))
        .pipe(gulp.dest("public/js"));
    });

    return "bundle-" + name;
};

gulp.task("bundle", [
    mkBundleTask("file", "Entries.File"),
    mkBundleTask("notebook", "Entries.Notebook")
]);

gulp.task("less", function() {
    return gulp.src(["less/main.less"])
        .pipe(less({ paths: ["less/**/*.less"] }))
        .pipe(gulp.dest("public/css"));
});

gulp.task("watch-less", ["less"], function() {
    return gulp.watch(["less/**/*.less"],
                      ["less"]);
});

gulp.task("watch-file", ["bundle-file"], function() {
    watch(sources.concat(foreigns), function() {
        gulp.start("bundle-file");
    });
});

gulp.task("watch-notebook", ["bundle-notebook"], function() {
    watch(sources.concat(foreigns), function() {
        gulp.start("bundle-notebook");
    });
});

gulp.task("make-test", function() {
    return purescript.psc({
        src: sources.concat(testSources),
        ffi: foreigns.concat(testForeigns)
    });
});

gulp.task("watch-test", ["make-test"], function() {
    watch(sources.concat(testSources).concat(foreigns).concat(testForeigns),
          function() {
              gulp.start("make-test");
          });
});

gulp.task("bundle-test", ["make"], function() {
  return purescript.pscBundle({
    src: "output/**/*.js",
    output: "tmp/test.js",
    module: "Test.Selenium",
    main: "Test.Selenium"
  });
});

gulp.task("test", ["bundle-test"], function() {
    require("./test/main.js");
});

gulp.task("default", ["watch-less", "watch-file", "watch-notebook"]);

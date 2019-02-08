'use strict';

var gulp          = require('gulp');
var sass          = require('gulp-sass');
var coffee        = require('gulp-coffee');
var sourcemaps    = require('gulp-sourcemaps');
var autoprefixer  = require('gulp-autoprefixer');
var fileinclude   = require('gulp-file-include');
var htmlmin       = require('gulp-htmlmin');
var browserSync   = require('browser-sync').create();

gulp.task('sass', function () {
  return gulp.src('./sass/**/*.sass')
    .pipe(sourcemaps.init())
    .pipe(sass({outputStyle: 'compressed'}).on('error', sass.logError))
    .pipe(autoprefixer({browsers: ['last 2 versions'], cascade: false}))
    .pipe(sourcemaps.write('./'))
    .pipe(gulp.dest('./dist/css'))
    .pipe(browserSync.stream());
});
 
gulp.task('sass:watch', function () {
  gulp.watch('./sass/**/*.sass', ['sass']);
});


gulp.task('coffee', function() {
  return gulp.src('./coffee/**/*.coffee')
    .pipe(sourcemaps.init())
    .pipe(coffee({bare: true}))
    .pipe(sourcemaps.write('./'))
    .pipe(gulp.dest('./dist/js'));
});

gulp.task('coffee:watch', function () {
  gulp.watch('./coffee/**/*.coffee', ['coffee']);
});


gulp.task('fileinclude', function() {
  return gulp.src(['src/**/*.html'])
    .pipe(fileinclude({
      prefix: '@@',
      basepath: '@root',
      context: {
        "base_url": "/schlaflabor", ///schlaflabor
        "base_path": "/schlaflabor/", ///schlaflabor
        "domain_name": "",
        "facebook_link": "",
        "mailto_link": "office@helios-schlaflabor.at",
        "site_title": "Helios Technology GmbH"
      }
    }))
    .pipe(htmlmin({collapseWhitespace: true}))
    .pipe(gulp.dest('./dist'));
});

gulp.task('default', ['sass', 'sass:watch', 'coffee', 'coffee:watch', 'fileinclude'], function() {
  
  browserSync.init({
    server: {
      baseDir: "./dist"
    }
  });

  return gulp.watch(["inc/**/*.html", "src/**/*.html"], ['fileinclude']).on('change', browserSync.reload);
});
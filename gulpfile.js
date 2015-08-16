/**
 * Expose cake commands with gulp for use by WebStorm
 *
 */
var gulp = require('gulp');
var shell = require('gulp-shell');

gulp.task('build', shell.task(['npm run build']));
gulp.task('dist', shell.task(['npm run dist']));
gulp.task('get', shell.task(['npm run get']));
gulp.task('deploy', shell.task(['npm run deploy']));
gulp.task('serve', shell.task(['npm run serve']));
gulp.task('test', shell.task(['npm run test']));
gulp.task('make:build', shell.task(['cake make:build']));

gulp.task('manifest:appcache', function() {
  manifest = require('gulp-manifest')

  gulp.src(["build/web/**/*.*"])
  .pipe(manifest(
      hash: true
      timestamp: true
      preferOnline: false
      network: ['*']
      filename: 'manifest.appcache'
      exclude: 'manifest.appcache'
    ))
  .pipe(gulp.dest("build/web"))
});

gulp.task('publish:gh-pages', function() {
  var ghPages = require('gulp-gh-pages');
  return gulp.src('./build/web/**/*')
    .pipe(ghPages());
});
@echo off
E:
cd E:\Blog-hugo\public
cmd /k "git remote rm origin https://github.com/scofield1920/scofield1920.github.io.git && git init && git add . && git remote add origin https://github.com/scofield1920/scofield1920.github.io.git && git push -u origin main"


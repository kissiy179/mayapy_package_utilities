@echo off

set SRC=%cd%\..\.git\modules\%DIR_NAME%\hooks\post-merge
set DST= %cd%\parent_githooks\post-merge    
mklink %DST% %SRC%

pause
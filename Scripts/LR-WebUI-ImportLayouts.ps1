<#
.NAME                                                                                                                                                                            
LR-WebUI-ImportLayouts

.SYNOPSIS
Bulk Import Dashboard or Analyse Layouts into the LogRhythm WebUI.

.DESCRIPTION
This script batch imports LogRhythm WebUI Analyse & Dashboard layouts from a user specified directory by taking the JSON format layout and inserting directly into the SQL EMDB database. 
This has been developed and tested against LogRhythm 7.3.x, and at best should be considered experimental, and not officially supported by LogRhythm.

Do not use on production systems.  Do not use without an up to date EMDB backup.  In fact, the more I think about it you probably just shouldn't every use it.  You have been warned!

.EXAMPLE
./LR-WebUI-ImportLayouts -path "c:\temp\path\to\my\layouts\"

.PARAMETER
-path = folder containing your webui layouts, be warned this does recurse sub-directories.

.NOTES
Dec 2017 @chrismartin

.LINK
https://github.com/lrchma/
#>

param(
  [Parameter(Mandatory=$true)]
  $scriptPath = ".")


trap [Exception] {
	write-error $("Exception: " + $_)
	exit 1
	}

#Loop through user provided directory for any webui files
$files = Get-ChildItem -Path $scriptPath -Recurse -Depth 1 -Include *.wdlt

#check to see if any wdlt files were found
if(!$files)
{
    write-output "For never was a story of more woe than this failed attempt to find a WebUI layout."
}


foreach($inputfile in $files){
    
    $layout = Get-Content -Raw -Path $inputfile | ConvertFrom-Json

    $sqlServer = "."                      #hard coded sql server alert, good job
    
    $createdby = -100
    $ownedby = -100
    $isprivate = 1                        #this always seems be 1, we'll go with that
    $now = Get-Date -Format s             #ISO8601 date format

    #Insert New Layout

    ## Sometimes existing layouts have null fields and that'll break import, not sure why that's the case but workaround it by inserting some default values

    $sqlQuery1 = "INSERT INTO web_layout VALUES (N'{0}',N'{1}',N'{2}',{3},{4},{5},{6},N'{7}',{8},{9},N'{10}');" -f $layout.name, $now, $now, $(if(!$layout.position){0}else{$layout.position}), $layout.columns, $createdby, $ownedby, $layout.pageName, $(if(!$layout.version){1}else{$layout.version}), $isprivate, $layout.filterQuery
    $ds1 = Invoke-Sqlcmd -Query $sqlQuery1 -ServerInstance $sqlServer -Database "LogRhythmEMDB"

    #### write-host $sqlQuery1 -ForegroundColor Yellow

    #Get New LayoutID, we need this to link each widget to and resultant widget settings
    $sqlQuery2 = "SELECT TOP 1 Web_LayoutID FROM Web_Layout ORDER BY Web_LayoutID DESC;"
    $ds2 = Invoke-Sqlcmd -Query $sqlQuery2 -ServerInstance $sqlServer -Database "LogRhythmEMDB"
    $newlayoutid = $ds2 | %{'{0}' -f $_[0]}

    #### write-host $newlayoutid -ForegroundColor Green
    #### write-host $sqlQuery2 -ForegroundColor Green

    #Insert each widget
    foreach($widget in $layout.widgets){
        
        #### write-host $widget.cid, $newlayoutid -ForegroundColor Red

        $sqlQuery3 = "INSERT INTO web_widget VALUES ({0},N'{1}',N'{2}',{3},{4},{5},{6},N'{7}',N'{8}');" -f $newlayoutid, $widget.name, $widget.type, $widget.x, $widget.y, $widget.width, $widget.height, $now, $now
        $ds3 = Invoke-Sqlcmd -Query $sqlQuery3 -ServerInstance $sqlServer  -Database "LogRhythmEMDB"
    
        ## write-host $sqlQuery3 -ForegroundColor Red

        $sqlQuery4 = "SELECT TOP 1 [Web_WidgetID] FROM [Web_Widget] WHERE [Web_LayoutID] = $newlayoutid ORDER BY Web_WidgetID DESC;"
        $ds4 = Invoke-Sqlcmd -Query $sqlQuery4 -ServerInstance $sqlServer  -Database "LogRhythmEMDB"
        $webwidgetid = $ds4 | %{'{0}' -f $_[0]}

        ## write-host $webwidgetid -ForegroundColor Cyan
        ## write-host $sqlQuery4 -ForegroundColor Cyan

        foreach($setting in $widget.settings){
            $sqlQuery5 = "INSERT INTO [Web_WidgetSetting] VALUES ({0},N'{1}',N'{2}',N'{3}',N'{4}');" -f $webwidgetid, $setting.type, $setting.selectedoption, $now, $now
            $ds5 = Invoke-Sqlcmd -Query $sqlQuery5 -ServerInstance $sqlServer  -Database "LogRhythmEMDB"
        
            ## write-host $sqlQuery5 -ForegroundColor Magenta
    
        }

    }

"{0} layout {1} added." -f $layout.pageName, $layout.name

}

write-output "Fin."
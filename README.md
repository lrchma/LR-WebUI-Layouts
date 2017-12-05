# WebUI-Layouts

This repository contains a collection of suggested best practises for LogRhythm WebUI Dashboard & Analyse layouts that focus on providing a clear and simple view to highlight areas of interest.  Not all metadata fields will be popualted by all log sources, and so these layouts focus on high value metadata fields that are common to all log sources.  For specific App log sources please see the [LR-LogSources](https://github.com/lrchma/LR-LogSources) repository.  When you find something of interest, that's the time to  either switch to a specific application centric view, or make use of the megagrid.

The use of standard Widgets (Bar Charts with the focus on the value field) and colour schema provide an intuative view upon large sets of metadata.  In addition, time based layouts and top/bottom views provide a quick way to detect outliers.

All layouts have been created using LogRythm 7.2.x or greater and default to 4 column width layout.  It's suggested to use the WebUI keyboard shortcuts for (L)ogs, (C)ase and (I)nspector to retain maximum screen estate while using the LogRhythm WebUI.

## Colour Use for Widgets
* Grey = Taxonomy
* Blue = Entity & Log Source
* Yellow = Hosts
* Green = Users

## Dashboards

### _1. Default (Time Range)
![Time Range Dashboard](https://github.com/lrchma/WebUI-Layouts/blob/master/Dashboard/_1%20Default%20Time%20Range.png?raw=true)

Provides time based comparison between metadata fields showing the last 1 hour vs the last 1 day:
* Top Classification 
* Top Common Event
* Top Log Source Trend
* Top Host (Origin)
* Top Host (Impacted)
* Top User (Origin)
* Top User (Impacted)

### _1. Default (Top & Bottom)
![Top and Bottom Events] (https://github.com/lrchma/WebUI-Layouts/blob/master/Dashboard/_1%20Default%20Top%20Events.png?raw=true)

Provides Top 10 metadata fields view.
* Top Classification
* Top Common Event
* Top Vendor Message ID
* Top Log Source
* Top Host (Origin)
* Top Host (Impacted)
* Top User (Origin)
* Top User (Impacted)
* Top Classification Trend

### _1. AIE Events
![Top Events Dashboard](https://github.com/lrchma/WebUI-Layouts/blob/master/Dashboard/_1%20Default%20Top%20Events.png?raw=true)

Provides Top 10 metadata fields view across AIE Events only.
* Top Common Event Trend
* Top Classification
* Top Common Event
* Top Log Source Entity
* Bottom Classification
* Bottom Common Event
* Bottom Log Source Entity

# WebUI Naming Convention
The WebUI has a display limit of 22 characters at this time, no filtering, and no folder structure.  Given that, without a naming convention it can become difficult to find the Dashboard or Analyse layout you're after quickly; however, there are many ways around that, and one such way isto define and use a naming convention:

Source:Dashboard (D|A-T|B)

Source = Brief Log Source Name, e.g., Apache
Dashboard = What the Dashboard or Analyse is for, e.g., Access Logs
D|A = Dashboard or Analyse (this is kinda obvious!)
T|B = Top or Bottom (Optional, if you don't use Top or Bottom views then omit)

The end result for Apache Access logs would be as follows:

Apache:Access (D-T)

# Converting Dashboards to Analyse Layouts and vice versa
The easiest and quickest way to convert a Dashboard to Analyse or vice versa is as follows:
1. Export your Dashboard or Analyse layout
2. In your favourite editor, find and replace the following:
..*"pageName":"Dashboard" to "pageName":"Analyse"
3. Save and create a view in your WebUI from new Dashboard or Analyse layout

Note, not all widgets are available sa Analyse layouts, in fact only TopX can be used.  If you've used anything else, such as CloudAI, GeoMap, etc... then the above won't work.  The workaround to this is create a copy of your Dashboard minus these widgets, then export and convert that into an Analyse layout.

# Converting Dashboards or Analyse layouts from Top to Bottom or vice versa

There's currently no way to switch all the widgets on a Dashboard or Analyse layout from Top to Bottom X items, or vice versa.  The workaround for this is as follows:
1. export the layout
2. open with your favourite editor
3. replace as follows
..* Search: "selectedOption":"Top" Replace: "selectedOption":"Bottom"
4. Import and away you go (or else, use the LR-WebUI-Importer.ps1 script)



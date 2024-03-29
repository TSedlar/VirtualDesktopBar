[Rainmeter]
OnRefreshAction=[!CommandMeasure SetResolution "Run"][!Update][!CommandMeasure WorkspaceCreator "SetDesktopData()"][!Update][!CommandMeasure CreateDesktops "Run"][!CommandMeasure SetCurrentDesktop "Run"]
OnUpdateAction=[!CommandMeasure SetCurrentDesktop "Run"]

; Do not reconfigure
[Variables]
MainConfigFile=#CURRENTPATH#/#CURRENTFILE#
SwitcherExecutable=#CURRENTPATH#/assets/desktop_switcher.exe
DesktopCount=1
DesktopTarget=1

[PanelIndicator]
Meter=Shape
SolidColor=#PanelIndicatorColor#

[SetResolution]
Measure=Plugin
Plugin=RunCommand
Program=#SwitcherExecutable#
Parameter="getTaskbarPos"
OutputType=ANSI
FinishAction=[!UpdateMeasure SetResolution][!CommandMeasure WorkspaceCreator "SetResolution(#SCREENAREAWIDTH#, #SCREENAREAHEIGHT#)"]

[SetCurrentDesktop]
Measure=Plugin
Plugin=RunCommand
Program=#SwitcherExecutable#
Parameter="getCurrentDesktop"
OutputType=ANSI
FinishAction=[!UpdateMeasure SetCurrentDesktop][!CommandMeasure WorkspaceCreator "SetCurrentDesktop()"]

[SetDesktop]
Measure=Plugin
Plugin=RunCommand
Program=#SwitcherExecutable#
Parameter="setDesktop #DesktopTarget#"
OutputType=ANSI
DynamicVariables=1

[CreateDesktops]
Measure=Plugin
Plugin=RunCommand
Program=#SwitcherExecutable#
Parameter="createDesktops #DesktopCount#"
OutputType=ANSI
DynamicVariables=1

[WorkspaceCreator]
Measure=Script
ScriptFile=#CURRENTPATH#/assets/Tab.lua
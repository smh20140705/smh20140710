smh20140710
===========

NAMES
* "Shah Hussain" is the author of this Xcode project.
* "smh20140705" is a github account created in advance for a tech test arising and is also used as the Xcode project's company name.
* "smh20140710" is the date-related name of the Xcode project.

SPEC CLARIFICATIONS
* Autolayout not used according to clarification.

DESIGN DECISIONS
* The sex of each contact is taken as a string in order to avoid having to consider in advance all of the various forms this might be specified: e.g. "m", "M", "male", "man", "boy", ... perhaps even "fellow", "fella", "geezer", etc, etc.
* Uses core data so that the app is able to display previous data if no connection is available.
* Uses KVC for parsing so core data attribute names correspond to xml elements names.
* Caches images to file and checks cache before attempting download.

IMPROVEMENTS
* Handling of different sized pictures could be improved.
  - tableview looks very irregular.
  - details view looks poorly arranged for wide pictures.
* testFetchDataWithCompletionHandler() is not a true unit test as it can be broken by changing the online Data.xml source file.
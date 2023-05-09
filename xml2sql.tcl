#! /usr/bin/tclsh

# ------------------------------------------------------------------------------
#
#   xml2sql.tcl
#   Copyright Data Virtuality GmbH 2023
#
#   Parses complex XML or JSON documents and creates a SQL query to fetch all data
#
# ------------------------------------------------------------------------------


package require tdom



# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
#                      XML PARSING PART
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------


proc normalizeXPath {path} {
  regsub -all {\[\d+\]} $path {}
}

# ------------------------------------------------------------------------------

proc relpath {leaf path} {

    # @c Calculates the relative path from the $leaf path to the desired $path

    set res ""
    set diff [regsub ***=$path $leaf {} ]
    foreach el [file split $diff] {
        if {$el eq {/}} {
            continue
        }
        set res [file join $res ..]
    }
    return $res
}

# ------------------------------------------------------------------------------

proc queryFromXmlAtt {node leafPath} {
    
    # @c Creates a 'COLUMNS' line for each node attribute
    # @a node: tdom node object
    # @a leafPath: XPath to the leaf node in relation to which to calculate paths

    set xpath [normalizeXPath [$node toXPath]]
    set result ""
    foreach att [$node attributes] {
        set name "$xpath/$att"
        set relpath [relpath $leafPath $xpath]
        set path "'[file join $relpath @${att}]'"
        append result "\"$name\" STRING PATH $path,\n"
    }
    return $result
}

# ------------------------------------------------------------------------------

proc queryFromXmlText {node leafPath} {

    # @c Creates a 'COLUMNS' line for node's text value, if any
    # @a node: tdom node object
    # @a leafPath: XPath to the leaf node in relation to which to calculate paths

    set xpath [normalizeXPath [$node toXPath]]
    set text [$node text]
    if {$text ne {}} {
        set name "$xpath/text"
        set relpath [relpath $leafPath $xpath]
        set path "'[file join $relpath text()]'"
        return "\"$name\" STRING PATH $path,\n"
    }
}

# ------------------------------------------------------------------------------

proc getparts {node} {

    #
    # For Leaf nodes, simply return 'COLUMNS' section and the xpath
    #

    set xpath [normalizeXPath [$node toXPath]]
    
    if {![$node hasChildNodes]} {
        set leafPath $xpath
        set myQuery [queryFromXmlAtt $node $leafPath]
        return [list $leafPath $myQuery]
    }

    #
    # For parent nodes, recurse into children
    #

    set parts [dict create]
    set cpath ""
    set cquery ""

    foreach child [$node childNodes] {

        #
        # expect to possibly receive more than 1 result pair!
        #

        set cparts [getparts $child]
        foreach {cpath cquery} $cparts {
            
            if {[dict size $parts] == 0} {
                dict set parts $cpath $cquery
            } elseif {[dict exists $parts $cpath]} {
                continue
            } else {
                set found 0
                foreach path [dict keys $parts] {
                    if {[string match $path* $cpath]} {

                        #
                        # current path is a substring of child path 
                        # --> child node is nested deeper and is a better leaf
                        #

                        dict set parts $cpath $cquery
                        dict unset parts $path
                        set found 1
                    }
                }
                if {!$found} {
                    dict set parts $cpath $cquery
                }
            }
        }
    }

    #
    # Add own attributes to each branch
    #

    foreach path [dict keys $parts] {
        dict append parts $path [queryFromXmlAtt $node $path]
        dict append parts $path [queryFromXmlText $node $path]
    }

    return [dict get $parts]
}

# ------------------------------------------------------------------------------

proc buildQuery {qparts dsource fpath} {

    set sql ""
    set count 1
    set tables [list]
    set firstLine "SELECT "
    
    append sql "FROM\n"
    append sql "(SELECT XMLPARSE(DOCUMENT f.file) as xmldata FROM "
    append sql "\"$dsource\".getFiles('$fpath') f) as data,\n"

    set first 1
    foreach leafPath [dict keys $qparts] {   
        set mytable "table$count"
        lappend tables $mytable
        append firstLine "$mytable.*, "

        if {!$first} {
            append sql ","
        }
        
        append sql "XMLTABLE('$leafPath' PASSING data.xmldata\n"
        append sql "COLUMNS\n\"idColumn_$count\" FOR ORDINALITY, \n"
        
        
        append sql "[dict get $qparts $leafPath]\n"

        set sql [string trimright $sql ",\n"]
        append sql "\n) \"$mytable\"\n"

        set first 0
        incr count 1
    }
    set firstLine [string trimright $firstLine ", "]
    set sql "$firstLine\n$sql\n;;"
}


# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
#                      JSON PARSING PART
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------


proc jsonChildren {node} {
    # @c Select all proper children nodes =>
    # @c     do not have '@' in their name || name = objectcontainer

    $node selectNodes {*[not(contains(name(),"@") or contains(name(),"objectcontainer"))]}
}

proc jsonAttributes {node} {
     # @c Select all children nodes that have '@' in their name

    set atts [$node selectNodes {*[contains(name(),"@")]}]
    lappend atts {*}[$node selectNodes {objectcontainer[1]/*[contains(name(),"@")]}]
}

# ------------------------------------------------------------------------------

proc queryFromJsonAtt {node leafPath} {

    set xpath [normalizeXPath [$node toXPath]]
    set result ""
    foreach attNode [jsonAttributes $node] {
        set name [$attNode nodeName]
        set name [string trimleft $name @]
        set relpath [relpath $leafPath $xpath]
        set path "'[file join $relpath _u0040_$name text()]'"
        append result "\"[file join "root" $xpath $name]\" STRING PATH $path,\n"
    }
    return $result
}

# ------------------------------------------------------------------------------



# ------------------------------------------------------------------------------

proc getpartsJson {node} {

    set xpath [normalizeXPath [$node toXPath]]
    set children [jsonChildren $node]

    if {$children eq {}} {
        set leafPath $xpath
        set myQuery [queryFromJsonAtt $node $leafPath]
        return [list [file join root $leafPath] $myQuery]
    }

    set parts [dict create]
    set cpath ""
    set cquery ""

    foreach child $children {
        set cparts [getpartsJson $child]
        foreach {cpath cquery} $cparts {
            if {[dict size $parts] == 0} {
                dict set parts $cpath $cquery
            } elseif {[dict exists $parts $cpath]} {
                continue
            } else {
                set found 0
                foreach path [dict keys $parts] {
                    if {[string match $path* $cpath]} {
                        dict set parts $cpath $cquery
                        dict unset parts $path
                        set found 1
                    }
                }
                if {!$found} {
                    dict set parts $cpath $cquery
                }
            }
        }
    }

    foreach path [dict keys $parts] {
        dict append parts $path [queryFromJsonAtt $node $path]
        # queryFromXmlText works also for Json nodes that don't have @ in the name
        dict append parts $path [queryFromXmlText $node $path]
    }

    return [dict get $parts]

}

# ------------------------------------------------------------------------------

proc buildQueryJson {qparts dsource fpath} {

    set sql ""
    set count 1
    set tables [list]
    set firstLine "SELECT "
    
    append sql "FROM\n"
    append sql "(SELECT JSONTOXML('root',to_chars(f.file,'UTF-8')) as xmldata FROM \"$dsource\".getFiles('$fpath') f) as data,\n"

    set first 1
    foreach leafPath [dict keys $qparts] {   
        set mytable "table$count"
        lappend tables $mytable
        append firstLine "$mytable.*, "

        if {!$first} {
            append sql ","
        }
        
        append sql "XMLTABLE(XMLNAMESPACES('http://www.w3.org/2001/XMLSchema-instance' as \"xsi\"),'root$leafPath'\n"
        append sql "PASSING data.xmldata\n"
        append sql "COLUMNS\n\"idColumn_$count\" FOR ORDINALITY, \n"
        
        append sql "[dict get $qparts $leafPath]\n"

        set sql [string trimright $sql ",\n"]
        append sql "\n) \"$mytable\"\n"

        set first 0
        incr count 1
    }
    set firstLine [string trimright $firstLine ", "]
    set sql "$firstLine\n$sql\n;;"
}


# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
#
#                   MAIN PROGRAM
#
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------

proc parseargs {args} {
    foreach {arg val} $args {
        switch $arg {
            -dsname - 
            -dspath -
            -infile -
            -outfile -
            -root {
                set varname [string trimleft $arg "-"]
                upvar $varname myvar
                set myvar $val
            }
        }
    }
}

proc usage {command} {
    set txt "Usage: $command -dsname <data source name> -dspath <file path within data source>"
    append txt " -infile <input file path> -outfile <output file path> -root <XPath to the root node>\n\n"
    append txt "Example: $command -dsname my_file_datasource -dspath ./input.xml -infile xmldata/file03.xml -root /root/FOLDER/"
    return $txt
}

# ------------------------------------------------------------------------------

proc xml2sql {args} {

    # @c Creates a SQL query to select all data from the given XML using XMLTABLE command
    # @c 
    # @a -dsname: Data source name in Data Virtuality. This is used as-is to create the FROM part
    # @a -dspath: File path of the XML file within DV. Used as-is to create the FROM clause.
    # @a -infile: Actual path to the XML file used as input to create the SQL statement.
    # @a -outfile: [Optional] output file. Defaults to "out.sql" in the current folder.
    # @a -root: [Optional] XPath to the XML node to be used as the document root.

    set dsname {INSERT_DATA_SOURCE_NAME_HERE}
    set dspath {INSERT_FILE_PATH_HERE}
    set infile ""
    set outfile "out.sql"
    set root ""
    
    if {[llength $args] == 0} {
        puts [usage "xml2sql"]
        return
    }
    parseargs $args
    
    set infile "sample-data/s01.xml"

    set fp [open $infile r]
    set xml [read $fp]
    close $fp

    set doc [dom parse $xml]
    if {$root eq {}} {
        set root [$doc documentElement]
    } else {
        if {[catch {$doc selectNodes $root} root]} {
            return "Error selecting the root node: $root"
        }
    }

    set parts [getparts $root]
    set sql [buildQuery $parts $dsname $dspath]

    set fp [open $outfile w]
    puts -nonewline $fp $sql
    close $fp
}

# ------------------------------------------------------------------------------

proc json2sql {args} {

    # @c Creates a SQL query to select all data from the given XML using XMLTABLE command
    # @c 
    # @a -dsname: Data source name in Data Virtuality. This is used as-is to create the FROM part
    # @a -dspath: File path of the JSON file within DV. Used as-is to create the FROM clause.
    # @a -infile: Actual path to the JSON file used as input to create the SQL statement.
    # @a -outfile: [Optional] output file. Defaults to "out.sql" in the current folder.
    # @a -root: [Optional] XPath to the JSON node to be used as the document root.

    set dsname {INSERT_DATA_SOURCE_NAME_HERE}
    set dspath {INSERT_FILE_PATH_HERE}
    set infile ""
    set outfile "out.sql"
    set root ""
    
    if {[llength $args] == 0} {
        puts [usage "json2sql"]
        return
    }
    parseargs $args

    set fp [open $infile r]
    set json [read $fp]
    close $fp

    set doc [dom parse -json $json]
    if {$root eq {}} {
        set root [$doc selectNodes "/"]
    } elseif {[catch {$doc selectNodes $root} root]} {
        return "Error selecting the root node: $root"
    }

    set parts [getpartsJson $root]
    set sql [buildQueryJson $parts $dsname $dspath]

    set fp [open $outfile w]
    puts -nonewline $fp $sql
    close $fp
}


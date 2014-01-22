#!/bin/bash
#
# Replaces include paths with known headers.
# 
# Options (environment variables):
# 
# DOIT [default: undefined] if set to non-zero, performs the substitution
# VERBOSE [default: undefined] if set to non-zero, prints unknown headers
#
# Changes:
# 20140122 (petrillo@fnal.gov) - first version
#


function ReplaceHeaders() {
	# Replaces all the include directives with fully qualified paths
	#
	local BasePackagePath="$1" # GIT package path
	local PackagesSubPath="$2" # subpackages base path (excluded BasePackage)
	local HeaderKeyword="$3"   # which headers need to be checked (regex)
	local SourceVeto="$4"      # which headers must not be touched (regex)
	
	local BasePackage="$(basename "$BasePackagePath")"
	
	# parse all the files in the package one by one:
	local SourceFile
	find "$BasePackagePath" -type f | while read SourceFile ; do
		
		[[ -n "$SourceVeto" ]] && [[ "$SourceFile" =~ $SourceVeto ]] && continue
		
		local Package="$(sed -e "s@${BasePackagePath}/${PackagesSubPath}/\([^/]*\)/.*@\1@" <<< "$SourceFile")"
		
		# collect the include lines into a buffer, which will be parsed line by line:
		grep -ie "#include.*${HeaderKeyword}" "$SourceFile" >> "$Pipe" &
		
		local NewFile=""
		
		local -i NIncludeFiles=0
		local IncludeLine
		while read IncludeLine ; do
			local IncludeFile="$(sed -e 's/^[::blank::]*#include \("\|<\)\(.*\)\("\|>\)[::blank::]*.*/\2/' <<< "$IncludeLine")"
			
			[[ "$IncludeFile" =~ \.fcl\$ ]] && continue
			[[ -n "$SourceVeto" ]] && [[ "$IncludeFile" =~ ${SourceVeto} ]] && continue
			
			NewIncludeFile="${PackagesSubPath}/${IncludeFile}"
			if [[ ! -r "${BasePackagePath}/${NewIncludeFile}" ]]; then
				NewIncludeFile="$(find "$BasePackagePath" -name "$(basename "$IncludeFile")" | sed -e "s@^${BasePackagePath}/@@" )"
			fi
			
			if [[ -n "$NewIncludeFile" ]] && [[ -r "${BasePackagePath}/${NewIncludeFile}" ]]; then
				if [[ "$((NIncludeFiles++))" == 0 ]]; then
					if [[ -d "${BasePackagePath}/${PackagesSubPath}/${Package}" ]]; then
						echo "${SourceFile} (${Package}):"
					else
						echo "${SourceFile} (package not found: ${Package}):"
					fi
				fi
				
				if [[ "$IncludeFile" == "$NewIncludeFile" ]]; then
					echo " - \"${IncludeFile}\" => already fixed"
					continue
				fi
				echo " - \"${IncludeFile}\" => \"${NewIncludeFile}\""
				
				if isFlagSet DOIT ; then
					if [[ -z "$NewFile" ]]; then
						local NewFile="${SourceFile}.new"
						cp -a "$SourceFile" "$NewFile"
					fi
					sed -i -e "s@\(\"\|<\)${IncludeFile}\(\"\|>\)@\1${NewIncludeFile}\2@g" "$NewFile"
				fi
				
			else
				if isFlagSet VERBOSE && [[ ! -r "$IncludeFile" ]]; then
					if [[ "$((NIncludeFiles++))" == 0 ]]; then
						if [[ -d "${BasePackagePath}/${PackagesSubPath}/${Package}" ]]; then
							echo "${SourceFile} (${Package}):"
						else
							echo "${SourceFile} (package not found: ${Package}):"
						fi
					fi
					
					echo " - \"${IncludeFile}\" => ???"
				fi
			fi
		done < "$Pipe"
		isFlagSet DOIT && [[ -r "$NewFile" ]] && mv "$NewFile" "$SourceFile"
	done

} # ReplaceHeaders()

function isFlagSet() {
	local VarName="$1"
	[[ -n "${!VarName//0}" ]]
} # isFlagSet()


################################################################################
Pipe="$(mktemp)"
rm -f "$Pipe"
mkfifo "$Pipe"

# The first parameter is the path to the local GIT repository;
# the next is the name of the code package (it's an existing directory);
# the third is a filter (regex): only headers whose name matched the specified
#   one are processed
# the last is also a filter: sources matching the pattern won't be processed,
#   and include directives including files which match that pattern won't be
#   touched either
#
# Using the third parameter as filter is safer but it missed some headers in
# LBNE code. Not using the filter produces a lot of unknown headers, and the
# relative warning messages are disabled by default, which might be dangerous;
# they can be enabled back by setting VERBOSE=1. But in this way some matches
# are recovered.
#
# ReplaceHeaders uboonecode uboone boone uboone_datatypes/
ReplaceHeaders uboonecode uboone '' uboone_datatypes/

# ReplaceHeaders lbnecode lbne lbne
ReplaceHeaders lbnecode lbne ''

if isFlagSet DOIT ; then
	echo "The replacements shown above have been applied."
else
	echo "If you are happy with the replacements above, run:"
	echo "DOIT=1 $0 $@"
fi

rm -f "$Pipe"

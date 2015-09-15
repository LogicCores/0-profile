#!/bin/bash -e
if [ -z "$HOME" ]; then
	echo "ERROR: 'HOME' environment variable is not set!"
	exit 1
fi
# Source https://github.com/bash-origin/bash.origin
. "$HOME/.bash.origin"
function init {
	eval BO_SELF_BASH_SOURCE="$BO_READ_SELF_BASH_SOURCE"
	BO_deriveSelfDir ___TMP___ "$BO_SELF_BASH_SOURCE"
	local __BO_DIR__="$___TMP___"

    export VERBOSE="1"

	function Encrypt {
		BO_format "$VERBOSE" "HEADER" "Encrypting new profile variables if found ..."

    	if [ -z "$PIO_PROFILE_KEY" ]; then
    	    echo "The 'PIO_PROFILE_KEY' environment variable must be set!"
    	    exit 1
    	fi
    	if [ -z "$PIO_PROFILE_SECRET" ]; then
    	    echo "The 'PIO_PROFILE_SECRET' environment variable must be set!"
    	    exit 1
    	fi

        # TODO: Make this search path configurable
        pushd "$__BO_DIR__/../../../../data" > /dev/null
            for nsDir in $(find ./* -type d); do
            	if [ -d "$nsDir/Deployments" ]; then
		            for locationDir in $(find $nsDir/Deployments/* -type d); do
		                "$__BO_DIR__/../../../../lib/pio.profile/bin/pio-profile-encrypt" \
		                    "$locationDir/profile.ccjson"
		            done
		        fi
            done
        popd > /dev/null

		BO_format "$VERBOSE" "FOOTER"
	}

	Encrypt $@
}
init $@
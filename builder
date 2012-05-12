#!/bin/zsh

SRCDIR=scripts

read -d '' HEADER <<"EOF"
(function() {
    var require = function(module) {
        return require.modules[module];
    }
    require.modules = {};
    var exports;
    var context;
EOF

read -d '' FOOTER <<"EOF"
}).call(this);
EOF

read -d '' MODULE_HEADER <<"EOF"
    exports = {};
    context = { window : window, document : document, require : require };
    (function(exports) {
EOF
read -d '' MODULE_FOOTER <<"EOF"
    }).call(context, exports);
    require.modules['MODULENAME'] = exports;
EOF

OUTFILEBASE=$(date +%Y%m%d%H%M%S)
OUTFILE=$OUTFILEBASE.js
SRCDIRLEN=$(expr ${#SRCDIR} + 1)

echo "// $OUTFILE" >> $OUTFILE
echo $HEADER >> $OUTFILE
for FILE in $(find $SRCDIR -name '*.coffee' | sort) ; do
    echo Processing $FILE
    echo "// $FILE" >> $OUTFILE
    MODULENAMELEN=$(expr ${#FILE} - 7 - $SRCDIRLEN)
    MODULENAME=${FILE:$SRCDIRLEN:$MODULENAMELEN}
    echo $MODULE_HEADER >> $OUTFILE
    echo "// source $FILE" >> $OUTFILE
    coffee -p --bare $FILE >> $OUTFILE
    echo "// end source $FILE" >> $OUTFILE
    echo $MODULE_FOOTER | sed "s:MODULENAME:$MODULENAME:" >> $OUTFILE
done
echo $FOOTER >> $OUTFILE
uglifyjs $OUTFILE > $OUTFILEBASE.min.js
cp $OUTFILEBASE.min.js LATEST.js

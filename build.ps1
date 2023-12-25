#!/usr/local/bin/pwsh
# =============================================================================
# MIT License
#
# © 2023 Mark Shaffer
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to
# deal in the Software without restriction, including without limitation the
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
# sell copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
# IN THE SOFTWARE.
# =============================================================================

[string]$STYLES = @"
/* Scroll Bar Configuration */
/* width */
::-webkit-scrollbar {
    width: 7px;
    height: 3px;
}
/* Track */
::-webkit-scrollbar-track {
    background: black;
}
/* Handle */
::-webkit-scrollbar-thumb {
    background: #888;
}
/* Handle on hover */
::-webkit-scrollbar-thumb:hover {
    background: #555;
}

[DOXYGEN]
"@

function build([string[]]$params) {
    # -------------------------------------------------------------------------
    # Constants
    # -------------------------------------------------------------------------
    [string]$PROJ_NAME = "CodeMelted Fullstack Module"
    # [string]$GEN_HTML_PERL_SCRIPT = "/ProgramData/chocolatey/lib/lcov/tools/bin/genhtml"

    # -------------------------------------------------------------------------
    # Helper Function
    # -------------------------------------------------------------------------
    function message([string]$msg) {
        Write-Host
        Write-Host "MESSAGE: $msg"
        Write-Host
    }

    # -------------------------------------------------------------------------
    # Main Build Script
    # -------------------------------------------------------------------------
    message "Now building $PROJ_NAME"

    message "Setting up the docs directory"
    Remove-Item -Path "docs" -Force -Recurse -ErrorAction Ignore

    # message "Running google test framework"
    # g++ -std=c++17 -fprofile-arcs -ftest-coverage melt_the_code.cpp `
    # melt_the_code_test.cpp -lgtest `
    # -lgtest_main -pthread -o test.exe
    # ./test.exe
    # gcov -r . melt_the_code.cpp
    # lcov -d . -c -o melt_the_code_coverage.info
    # lcov --remove melt_the_code_coverage.info -o melt_the_code_coverage_filtered.info `
    #     '/usr/local/include/*' '*v1*'

    # if ($IsLinux -or $IsMacOS) {
    #     genhtml -o "dist/melt_the_code_cpp/coverage" --dark-mode melt_the_code_coverage_filtered.info
    # }
    # Remove-Item -Path test.exe -Force
    # Remove-Item -Path melt_the_code_coverage.info -Force
    # Remove-Item -Path melt_the_code_coverage_filtered.info -Force
    # Remove-Item -Path melt_the_code_test.gcda -Force
    # Remove-Item -Path melt_the_code_test.gcno -Force
    # Remove-Item -Path melt_the_code.cpp.gcov -Force
    # Remove-Item -Path melt_the_code.gcda -Force
    # Remove-Item -Path melt_the_code.gcno -Force

    message "Generating doxygen"
    doxygen theme/doxygen.cfg
    [string]$htmlData = Get-Content -Path "docs/index.html" -Raw
    $htmlData = $htmlData.Replace('<p>&lt;script src="https://developer.codemelted.com/assets/js/codemelted_channel.js"&gt;&lt;/script&gt; </p>', '')
    $htmlData = $htmlData.Replace("</body>", "<script src='https://developer.codemelted.com/assets/js/codemelted_channel.js'></script></body>")
    $htmlData | Out-File docs/index.html -Force
    $doxygenCssData = Get-Content -Path "docs/doxygen.css" -Raw
    $doxygenCssData = $STYLES.Replace("[DOXYGEN]", $doxygenCssData)
    $doxygenCssData | Out-File docs/doxygen.css -Force
    # Move-Item -Path coverage -Destination docs -Force

    message "$PROJ_NAME build completed"


}
build $args
#
#	test_helper - Set up the test environment
#
#
#
#

do (template = require("../build/template")) ->



  Object.defineProperties @,

    # Use chai 'should' semantics
    should: value: require('chai').should()

    # The framework
    template: value: template


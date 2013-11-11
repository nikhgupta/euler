# Euler (Undergoing development at the moment... updated: 11 Nov. 2013)

[ProEuler][gem] is a gem that helps you solve [Project Euler][project] problems
more easily, and makes them a bit more fun. It allows you to add test cases for
your problems, compare your different approaches to the problem, identify
problems that exceed a given execution time, kill execution of solutions that
exceed a given execution time when writing them, and much more.

This gem can be used to solve problems using any language, but it really shines
when you use `ruby` to solve these problems.

## Installation

The gem can be installed by running the following command in your terminal:

    $ gem install euler

## Usage

### Initialization

The gem needs some configuration, which can be generated or modified by running
the following command:

    $ euler init

The configuration is stored inside `~/.euler/conf.yml` file, which can even be
edited by hand. An important variable of this configuration is `directory`,
which stores the location where any solutions/helpers created by you, will be
stored.

### Downloading Problems for Offline Access

This gem can download information about the given problems, and store them in
the cache for offline access, later on.

    $ euler download 21 25 -v      # download problem no. 21 and 25
    $ euler download 21 25 29-50   # download problem no. 21, 25, and 29 to 50

You should read [this Wiki Page][wiki-download] for more details.

### Generating Solution File

You can generate a solution file for your problem using the following command:

    $ euler create 4                      # create solution file
    # => ~/euler/solutions/euler_004.rb

    $ euler create 4 --template "inheritance.python"
    # => ~/euler/solutions/euler_004.py   # use template named 'inheritance.python.py'

You should read [this Wiki Page][wiki-solution] for more details.

If you would like to create a new template for your preferred language, please
read [this Wiki Page][wiki-template], as well.

### Adding test cases for your problem

Inside the generated solution file, you can use the following method to add
a test case for your problem:

    # test_case <input>, <output>
    test_case 10, 23
    test_case [20, 20], 6

### Working on solving a Problem

[This Wiki Page][wiki-workflow] deals with the workflow in more details.

### View your Progress

This method allows you to view your progress on [Project Euler][project].
Simply, run:

    $ euler progress

### Publish your Solutions

This method allows you to publish your solutions on [GitHub][github] by making
use of git. This, further, ensures that all your solutions are versioned,
correctly.

    $ euler publish

> Note that, you will need to create a [Github][github] repository with the
> name: `euler_solutions` before running this command, and add it as a remote
> when the command is run for the first time, or otherwise add it in the
> configuration file.

### Cheat Sheet

    $ euler init                     # initialize euler

    $ euler download 1-100           # download problem no. 1 to 100 for offline use

    $ euler create <id>              # generate solution file
    $ euler template                 # list available templates
    $ euler template --create <name> # create a new one.

    $ euler start <id>               # start working on a problem
    $ euler start --unsolved         # start on the first available unsolved problem
    $ euler start --optimize <time>  # start on a problem with execution time greater than <time> seconds
    $ euler pause [id]               # pause working on a problem
    $ euler finalize [id]            # stop working on a problem and finalize it.
    $ euler solve [id]               # run the solution for a problem with tests, if any.

    $ euler progress                 # displays the user's progress from website & gem
    $ euler publish                  # publish your solutions as a github repo

## ToDo List

- implement command: `publish`
- implement command: `progress`
- implement timer functionality
- implement environment method: `compare_approaches`
- implement environment method: `read_input`

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

[github]:        http://github.com "GitHub"
[gem]:           http://github.com/nikhgupta/euler "ProEuler"
[project]:       http://projecteuler.net "Project Euler"
[website]:       http://nikhgupta.com "Nikhil Gupta"
[wiki-workflow]: https://github.com/nikhgupta/euler/wiki/Workflow-for-solving-a-problem "Workflow for solving a problem"
[wiki-download]: https://github.com/nikhgupta/euler/wiki/HowTo:-Download-problems-for-offline-access "HowTo: Download problems for offline access"
[wiki-solution]: https://github.com/nikhgupta/euler/wiki/HowTo:-Generate-your-solution-file "HowTo: Generate your solution file"
[wiki-template]: https://github.com/nikhgupta/euler/wiki/HowTo:-Define-your-own-solution-templates "HowTo: Define your own solution templates"
[wiki-testcase]: https://github.com/nikhgupta/euler/wiki/HowTo:-Add-Test-Cases-and-other-functionality-inside-your-solutions "HowTo: Add Test Cases and other functionality inside your solutions"

Surviving Your First Day on the Job with Git
============================================

<hr>

Introductions
-------------

### Who the hell am I?

+ My name is Nathan Dotz (but you might know me as [sleepy nate][1])
+ I've written a lot of code in a variety of fields
+ I'm a founding member at [All Hands Active][AHA]
+ I work for [Detroit Labs][], basically the [A-Team][] of mobile development.

<hr>

### What the hell is a `git`?

`git` is a [distributed revision control system]
It allows us to:

+ Store files (usually source code) in a centralized location
+ Record changes to those files over time
+ Recall any specific change or set of changes later

However, there are many tools (specifically, svn is common these days) that
solve this same problem. Why would I want git?

<hr>

### But what makes `git` different?

+ `git` is in fact **distributed**. There is no central repository to control the
  flow of changes.

+ `git` is **non-linear**. Instead, Changes branch out in a web from the previous
  changes. Often, this is more of a tree shape, but it is important to note
  that unlike centrally controlled systems, development of change sets can
  branch out in many directions
 
+ `git` is **patch-based**. It does not operate on specifically on files, but
  rather on blobs of content.
  
+ `git` takes **snapshots**. While you may be interested in the differences between
  versions of files, `git` pays attention to what the repo looks like every
  time we *commit* to store a snapshot.

<hr>

Let's use some git
------------------

First, let's set up git to recognize us as an individual:

    $ git config --global user.email "e@mail.me"
    $ git config --global user.name  "Firsty McSurname"

Create a git repository:

    $ mkdir my-wicked-sweet-project
    $ cd my-wicked-sweet-project
    $ git init .

It's that easy! Now you have a repository.

<hr>

Now, we'll probably want to track something more than an empty directory, so 
let's go ahead and create a python program.

    $ echo 'print "Hello Git!"' > hello.py

Asking `git` about its *index* (we'll get to that in a moment) shows that
there is a file, and it is as yet not tracked. We do this with the `status` command

    $ git status

And tell our repository to track it.

    $ git add hello.py

<hr>

### WARNING: Technical crap -- the staging area.

* We have not actually done any tracking of our file
* Rather, we have added the file to `git`'s staging area
* The "staging area" is actually a `index` file with information about what 
  the next *commit* will be.
* We can even see that it is in our index by checking `.git/index` under our 
  repository's directory.
* A *commit* will actually store a binary snapshot of our files in the repository

<hr>

We can see the state of our index and the fact that our file is now staged
and ready to be tracked with `status` again

    $ git status

So let's *commit* our index to take our first snapshot.

    $ git commit -m 'First commit, our Hello Git python script'

The `-m` option after `commit` allows us to provide a message for our commit.
Had we not provided it, the system's default editor would have been launched
to allow us to specify a commit message. Providing a blank message cancels 
the commit.

<hr>

### Hurray we are tracking a file.

Prove it, ***sucker***.

<hr>

Let's change our file to be a littler more representative.

    $ sed -in 's/Hello/I am awesome at/g' hello.py
    
Now we can see that a change is present with

    $ git diff

The line that starts with `-` shows the previous state of our file, and the 
line with the `+` shows the current state of our file.

Let's commit this as well.

	$ git commit -a

The `-a` flag means "all the files we are tracking". Notice that this brings
up the editor to create our commit message.

<hr>

### We know what's changed

A simple `git log` will show us that we are in fact tracking changes
to our code base.

     $ git log

This should both of the commits we've made up to this point.

<hr>

### Rediscovering the past

So now we made some commits and it's been months (time flies, eh?).

We probably forgot whatever we were doing. The `git diff` we just learned
about can come in handy again. We can use the commit *hashcodes* to introspect
on our set of changes again. We would simply issue:

    $ git diff 520636 fd3bce
    
With `529636` being the first few numbers of the older entry and `fd3bce` 
being the first few numbers of the newer entry. 

<hr>

### Wanton tracking

Last I checked, I was mucking about in python. I imported my old module to
play with it, and created a new script.

    $ python -c 'import hello'
    $ echo 'print "The answer is %d " % (21 + 13 + 7 + 1)' \
      > everything.py

Being really excited, I'm ready to put my new file in git. Feeling cocky and
not interested in typing, I take a shortcut.

    $ git add * && git commit -am 'Now I know the answers.'
    
<hr>

### Something is wrong!

    [master 3ad8451] Now I know the answers.
     2 files changed, 1 insertion(+)
     create mode 100644 everything.py
     create mode 100644 hello.pyc    

The output shows some file I didn't even consider! `hello.pyc` is not 
something I want to track!

<hr>

### Cleaning up

Luckily, I can remove tracking of my mistake.

    $ git rm hello.pyc
    $ git commit -m 'oops! removing this file i do not want.'

This will:

+ remove the file from the file system
+ update the index to "forget" about the file in future commits

<hr>

### Ignoring detritus

I am quite sure I would not like to track the changes in compiled
binary files generated by python. I'd much rather not have to 
worry about `git` seeing them at all.

Luckily, `git` will pay attention to a *magic* file called 
`.gitignore`. It contains a list of [globs][] that `git` will
(perhaps unsurprisingly) *ignore*.

    $ echo '*.pyc' > .gitignore
    $ git add .gitignore
    $ git commit .gitignore -m 'Adding .gitignore to ignore pyc files'

<hr>

### Swept under the carpet

Now notice that if we create new .pyc files within our repository, 
they do not show up as "untracked" in our `status` and cannot be added

    $ python -c 'import hello'
    $ git status
    $ touch hurray{1..10}.pyc
    $ git status
    $ git add hurray1.pyc
    $ git status

<hr>

### Just giving up

Some times you screw up. There are two ways to scrap what you've done
with the `reset` command.

To remove things from the staging area, that you have accidentally 
added, you can use:

    $ git reset
    
However, you might also want to scrap the changes in a file you have made
and go back to whatever it was the last time you committed. This can be
accomplished by adding the `--hard` flag.

    $ echo 'DERP HURR' > hello.py
    $ python hello.py   # <- OH NO I HAVE DESTROYED MY FILE~!
    $ git reset --hard  # Give up, start over.

<hr>

### Branches

What happens when you want to try out something new without worrying about 
screwing up how things are currently. Well, you make a branch.

    $ git branch
    $ git branch try_a_thing
    $ git branch
    $ git checkout try_a_thing
    
Or you can use the shorthand -b flag to do the same thing:

    $ git checkout -b try_a_thing
    
<hr>

### A whole new world

Now we can make all the changes we want without worrying about disturbing
our master branch.

    $ sed -in 's/Git/Everything!/' hello.py
    $ git commit -m 'All I do is win'
    
Meanwhile, development can continue in our master branch

    $ echo 'import sys; print "We like %s" % " ".join(sys.argv[1:])' \
      > like_stuff.py 
    $ python like_stuff.py puppies
    $ python like_stuff.py dirty jokes
    $ git add like_stuff.py && git commit -am 'Liking things is good'
    $ git mv everything.py life_universe.py
    $ git commit -m 'rename!'
    $ git log --graph --all --color \
      --pretty=format:"%x1b[31m%h%x09%x1b[32m%d%x1b[0m%x20%s"
<hr>

### Don't walk away

We can see from our graph that our branches have diverged.

However, we can use the merge command to put them back together.

Let's merge `try_a_thing`into `master` so `master` will have all
the changes we made in `try_a_thing`.

    $ git merge try_a_thing master
    $ git log --graph --all --color \
      --pretty=format:"%x1b[31m%h%x09%x1b[32m%d%x1b[0m%x20%s"

We can see our branches have come together once again.

<hr>

### Remotes

A primary advantage of `git` is that it is *distributed*. I'm going
distribute my repo to github so others can share my repository.

After [creating a new repository on github][] I will need to add the
`remote`. A `remote` is another related repository, usually on a 
(wait for it…) *remote* server.

First though, let's create a remote on our own machine as an example.

<hr>

### Not so remote

Create a new repo in /tmp

    $ mkdir /tmp/fake-remote && cd $_
    $ git init .
    
Then add the first repository as a remote

    $ git remote add wicked-sweet ~/my-wicked-sweet-project

Now I can exchange information with my original repository using
`pull` and `push`.

<hr>

### Tug of war

With a `git pull` I can bring all the commits in my other repository 
into this one

    $ git pull wicked-sweet master
    
This performs a `fetch` of the `master` branch from the `wicked-sweet`
remote, and then `merges` that fetched branch with our local branch.

<hr>

### We're in effect, want you to

After making some changes here and committing them, I can then `push`
them back to the original repository with a command structure
similar to `pull`

    $ echo 'import os; print "Hello from %s" % os.getcwd()' > station_id.py
    $ git add station_id.py && git commit -m 'adding a new thinger'
    $ git push wicked-sweet master:from-fake
    
Now we're cooking… this creates a `branch` back in our `wicked-sweet`
repo named `from-fake` which is based off the `master` branch of this
repository.

<hr>

### Back in wicked-sweet

	$ cd ~/my-wicked-sweet-project
	$ git merge from-fake master
	$ ls station_id.py

We can see our changes are indeed in our repository.

Following this same pattern, we could replace our locale "remote"
repository with the address that *github* provides.

<hr>

### Additional commands to investigate

    $ git tag
    $ git stash

<hr>

Congratulations
---------------

You now know enough about `git` to trick someone into thinking
that you know what the hell you are talking about.

<hr>

But wait, there's more.
-----------------------

<hr>

### External tools that can be handy:

+ [GitX][]
+ [SourceTree][]
+ Github for [Mac](http://www.sourcetreeapp.com/) / [Windows](http://windows.github.com/)

<hr>

### Resources

+ [Pro Git][] (aka "The git book")
+ [Git Immersion][]
+ [Git from the bottom up][]

[1]: http://github.com/sleepynate
[AHA]: http://allhandsactive.com
[creating a new repository on github]: http://github.com/new
[Detroit Labs]: http://detroitlabs.com
[A-Team]: http://en.wikipedia.org/wiki/The_A-Team
[distributed revision control system]: http://en.wikipedia.org/wiki/Distributed_revision_control
[globs]: http://en.wikipedia.org/wiki/Glob_(programming)
[GitX]: http://gitx.frim.nl/
[SourceTree]: http://www.sourcetreeapp.com/
[Pro Git]: http://git-scm.com/book
[Git Immersion]: http://gitimmersion.com/
[Git from the bottom up]: http://ftp.newartisans.com/pub/git.from.bottom.up.pdf

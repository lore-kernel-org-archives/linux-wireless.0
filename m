Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vilya.visn.co.uk ([193.254.210.161]:54843 "EHLO
	vilya.visn.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207AbZBCQja (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2009 11:39:30 -0500
Message-ID: <44120.62.172.74.16.1233679156.squirrel@www.phantomjinx.co.uk> (sfid-20090203_173932_845333_605272E3)
In-Reply-To: <20090203142807.GC10968@tuxdriver.com>
References: <33918.62.172.74.16.1233233185.squirrel@www.phantomjinx.co.uk>
    <3ace41890901290952o6412c8dco660a36ffc2fcf485@mail.gmail.com>
    <41405.91.85.186.216.1233323986.squirrel@www.phantomjinx.co.uk>
    <3ace41890901301117na1a81e8g90b25d6e8ff469ae@mail.gmail.com>
    <35757.91.85.186.216.1233353086.squirrel@www.phantomjinx.co.uk>
    <3ace41890902011709h285b4e9bi40da145f841533ea@mail.gmail.com>
    <37630.82.152.223.193.1233582663.squirrel@www.phantomjinx.co.uk>
    <49871083.5040309@lwfinger.net>
    <35040.82.152.223.193.1233590184.squirrel@www.phantomjinx.co.uk>
    <3ace41890902021548o39b5f02veacc0bd650e92c7@mail.gmail.com>
    <20090203142807.GC10968@tuxdriver.com>
Date: Tue, 3 Feb 2009 16:39:16 -0000 (UTC)
Subject: Re: rtl8187 wireless issues
From: "P.G. Richardson" <p.g.richardson@phantomjinx.co.uk>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> On Mon, Feb 02, 2009 at 11:48:55PM +0000, Hin-Tak Leung wrote:
>
>> About dates in wireless-testing log - I had an impression (I could b=
e
>> wrong) that the dates are sometimes git-format-patch/posting dates a=
nd
>> not dates at which John commits to wireless-testing? (i.e. the dates
>> shown could be a lot earlier than time of commit, or time of commit =
is
>> not shown by the dates associated with a patch - I thought this make=
s
>> sense since the date of a patch should be the first time it appears =
in
>> the "system", not the first time it gets in-coporated in a particula=
r
>> tree, and patches can go between trees and should *not* pick up date
>> change on the way).
>
> Patch dates in 'git log' are based on their reported creation time or
> (for patches not from git) their posting time.  That's just the way
> git works (at least by default).
>
> I generally tag wireless-testing updates on the master branch with
> a date-based tag.  You can see them like this:
>
> 	git fetch --tags # just in case...
> 	git tag | grep master
>
> Hth!

Apologies. there might be some confusion. When I mentioned the date of =
the
30/01/2009, I was referring to the snapshot date of the tarball
downloaded, ie. compat-wireless-$(date -I).tar.bz2.

I haven't used wireless-testing's git repo thus far. If it will help wi=
th
the rate issue I have then will definitely install that version instead=
=2E

Cheers

PGR



--=20
Laws are partly formed for the sake of good men, in order to instruct t=
hem
how they may live on friendly terms with one another, and partly for th=
e
sake of those who refuse to be instructed, whose spirit cannot be subdu=
ed,
or softened, or hindered from plunging into evil. [The Laws, Plato]

You fiend! Never have I encountered such corrupt and foul-minded
perversity=85 Have you ever considered a career in the church?
Bishop of Bath and Wells (Blackadder II)

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

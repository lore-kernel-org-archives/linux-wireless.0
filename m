Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55799 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbZBCOax (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2009 09:30:53 -0500
Date: Tue, 3 Feb 2009 09:28:07 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Hin-Tak Leung <hintak.leung@gmail.com>
Cc: "P.G. Richardson" <p.g.richardson@phantomjinx.co.uk>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: Re: rtl8187 wireless issues
Message-ID: <20090203142807.GC10968@tuxdriver.com> (sfid-20090203_153056_913444_67CA9A83)
References: <33918.62.172.74.16.1233233185.squirrel@www.phantomjinx.co.uk> <3ace41890901290952o6412c8dco660a36ffc2fcf485@mail.gmail.com> <41405.91.85.186.216.1233323986.squirrel@www.phantomjinx.co.uk> <3ace41890901301117na1a81e8g90b25d6e8ff469ae@mail.gmail.com> <35757.91.85.186.216.1233353086.squirrel@www.phantomjinx.co.uk> <3ace41890902011709h285b4e9bi40da145f841533ea@mail.gmail.com> <37630.82.152.223.193.1233582663.squirrel@www.phantomjinx.co.uk> <49871083.5040309@lwfinger.net> <35040.82.152.223.193.1233590184.squirrel@www.phantomjinx.co.uk> <3ace41890902021548o39b5f02veacc0bd650e92c7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <3ace41890902021548o39b5f02veacc0bd650e92c7@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 02, 2009 at 11:48:55PM +0000, Hin-Tak Leung wrote:

> About dates in wireless-testing log - I had an impression (I could be
> wrong) that the dates are sometimes git-format-patch/posting dates and
> not dates at which John commits to wireless-testing? (i.e. the dates
> shown could be a lot earlier than time of commit, or time of commit is
> not shown by the dates associated with a patch - I thought this makes
> sense since the date of a patch should be the first time it appears in
> the "system", not the first time it gets in-coporated in a particular
> tree, and patches can go between trees and should *not* pick up date
> change on the way).

Patch dates in 'git log' are based on their reported creation time or
(for patches not from git) their posting time.  That's just the way
git works (at least by default).

I generally tag wireless-testing updates on the master branch with
a date-based tag.  You can see them like this:

	git fetch --tags # just in case...
	git tag | grep master

Hth!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

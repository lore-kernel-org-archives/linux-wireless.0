Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4071 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751267AbXLDQ6v (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Dec 2007 11:58:51 -0500
Date: Tue, 4 Dec 2007 11:57:45 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Dan Williams <dcbw@redhat.com>,
	Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
Subject: Re: [PATCH] fewer eventcause shifts
Message-ID: <20071204165745.GM19911@tuxdriver.com> (sfid-20071204_165853_118520_9B381E7E)
References: <200711280915.11300.hs4233@mail.mn-solutions.de> <1196704681.21151.13.camel@localhost.localdomain> <1196714939.13978.171.camel@pmac.infradead.org> <20071204145437.GC19911@tuxdriver.com> <1196780866.13978.275.camel@pmac.infradead.org> <20071204152122.GE19911@tuxdriver.com> <1196782170.13978.296.camel@pmac.infradead.org> <20071204161231.GI19911@tuxdriver.com> <1196785655.13978.333.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1196785655.13978.333.camel@pmac.infradead.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 04, 2007 at 04:27:35PM +0000, David Woodhouse wrote:
> On Tue, 2007-12-04 at 11:12 -0500, John W. Linville wrote:

> > Keeping a clean patch stack at the top is the only way I know to
> > come close to guaranteeing you have mergeable patches.  Beyond that,
> > I'll work with you the best that I can.
> 
> Again you're talking of 'patches'. But if we're using "git as git", then
> it isn't about guaranteeing you have mergeable _patches_. It's about
> guaranteeing you have a mergeable _tree_.

This might be true if there were a guarantee that no one would rebase
from you to me to Jeff/Dave to Linus.  Experience tells me that I can't
guarantee the "Jeff/Dave" part of that chain.  Given that, experience
also tells me that when your patches pop-up in their rebase operation
that they will look like your original commit and not have any fixups
included as part of any 'git merge' along the way.  So by not rebasing
your patches (or insisting that you do so) before sending them along,
I'm making life harder for Jeff/Dave.  Since they handle even more
patches than I do, that seems to fall under the "not cool" category.

> On Tue, 2007-12-04 at 11:14 -0500, John W. Linville wrote:
> > If the new patches come fast enough to guarantee that then I have to
> > believe that we can work-out how to merge the new patches on top of
> > what I've already sent.  So, I would prefer to let the pull request
> > I sent today stand.
> 
> OK, that's fine, I think. Because if you've actually sent the pull
> request, then I can use those _commits_ and those will be the ones which
> turn up upstream. Those patches won't get recommitted, cherry-picked,
> rebased or otherwise mangled so that they're no longer the same commits
> that I'm basing my tree on.

You might presume so, and you might even be right this time around.
But, I think you presume too much in this case.

> Which branch of yours contains the commits (not patches) which are
> actually going upstream? I'll throw away my tree and rebase it on that.

I have asked Jeff to pull the 'upstream-jgarzik' branch, which contains
the libertas patches.

John
-- 
John W. Linville
linville@tuxdriver.com

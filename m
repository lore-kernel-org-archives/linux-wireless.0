Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:54822 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbXLDQ2B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Dec 2007 11:28:01 -0500
Subject: Re: [PATCH] fewer eventcause shifts
From: David Woodhouse <dwmw2@infradead.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>,
	Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
In-Reply-To: <20071204161231.GI19911@tuxdriver.com>
References: <200711280915.11300.hs4233@mail.mn-solutions.de>
	 <1196704681.21151.13.camel@localhost.localdomain>
	 <1196714939.13978.171.camel@pmac.infradead.org>
	 <20071204145437.GC19911@tuxdriver.com>
	 <1196780866.13978.275.camel@pmac.infradead.org>
	 <20071204152122.GE19911@tuxdriver.com>
	 <1196782170.13978.296.camel@pmac.infradead.org>
	 <20071204161231.GI19911@tuxdriver.com>
Content-Type: text/plain
Date: Tue, 04 Dec 2007 16:27:35 +0000
Message-Id: <1196785655.13978.333.camel@pmac.infradead.org> (sfid-20071204_162809_611081_4D59FD7F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(the subject line was annoying me; I fixed it)

On Tue, 2007-12-04 at 11:12 -0500, John W. Linville wrote:
> On Tue, Dec 04, 2007 at 03:29:30PM +0000, David Woodhouse wrote:
> 
> > Basically, trees which get rebased aren't suitable for git users to base
> > their work on. It just doesn't work.
> 
> Well I think that is an overstatement, but you are entitled to it... :-)

Well, I am making the distinction between 'git as git' and 'git as quilt
storage'. If you interpret 'git users' to mean those who want the
former, it really isn't much of an overstatement at all.

> Again, I don't have any more libertas patches in queue.  So don't
> send any more until you are ready to merge and I don't think there
> will be a serious problem.

OK. 

> > I'm open to better suggestions, as long as they're not "you are not
> > allowed to use git, except as a primitive way of storing patches". :)
> 
> Keeping a clean patch stack at the top is the only way I know to
> come close to guaranteeing you have mergeable patches.  Beyond that,
> I'll work with you the best that I can.

Again you're talking of 'patches'. But if we're using "git as git", then
it isn't about guaranteeing you have mergeable _patches_. It's about
guaranteeing you have a mergeable _tree_.

On Tue, 2007-12-04 at 11:14 -0500, John W. Linville wrote:
> If the new patches come fast enough to guarantee that then I have to
> believe that we can work-out how to merge the new patches on top of
> what I've already sent.  So, I would prefer to let the pull request
> I sent today stand.

OK, that's fine, I think. Because if you've actually sent the pull
request, then I can use those _commits_ and those will be the ones which
turn up upstream. Those patches won't get recommitted, cherry-picked,
rebased or otherwise mangled so that they're no longer the same commits
that I'm basing my tree on.

Which branch of yours contains the commits (not patches) which are
actually going upstream? I'll throw away my tree and rebase it on that.

-- 
dwmw2


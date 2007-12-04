Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4618 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753562AbXLDQNd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Dec 2007 11:13:33 -0500
Date: Tue, 4 Dec 2007 11:12:31 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	Holger Schurig <hs4233@mail.mn-solutions.de>,
	libertas-dev@lists.infradead.org
Subject: Re: [PATCH] less eventcause shifts
Message-ID: <20071204161231.GI19911@tuxdriver.com> (sfid-20071204_161352_002814_477ECE94)
References: <200711280915.11300.hs4233@mail.mn-solutions.de> <1196704681.21151.13.camel@localhost.localdomain> <1196714939.13978.171.camel@pmac.infradead.org> <20071204145437.GC19911@tuxdriver.com> <1196780866.13978.275.camel@pmac.infradead.org> <20071204152122.GE19911@tuxdriver.com> <1196782170.13978.296.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1196782170.13978.296.camel@pmac.infradead.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 04, 2007 at 03:29:30PM +0000, David Woodhouse wrote:

> Basically, trees which get rebased aren't suitable for git users to base
> their work on. It just doesn't work.

Well I think that is an overstatement, but you are entitled to it... :-)

I don't know what else I can offer.  There may be some ways to
rebase 'everything' less often, but I don't think I can eliminate it
completely without having a big mess.

> Which is why I thought we'd agreed that I'll commit libertas-related
> stuff to libertas-2.6.git for now, where Holger and I can play to our
> hearts' content, then ask you to pull when we're done.

I just don't see where I have upset that apple cart.  Polish-up your
tree and I'll pull it.  I (or maybe we) will work it out from there.

Again, I don't have any more libertas patches in queue.  So don't
send any more until you are ready to merge and I don't think there
will be a serious problem.

> I'm open to better suggestions, as long as they're not "you are not
> allowed to use git, except as a primitive way of storing patches". :)

Keeping a clean patch stack at the top is the only way I know to
come close to guaranteeing you have mergeable patches.  Beyond that,
I'll work with you the best that I can.

John
-- 
John W. Linville
linville@tuxdriver.com

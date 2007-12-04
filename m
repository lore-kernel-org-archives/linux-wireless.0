Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3656 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753270AbXLDPW2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Dec 2007 10:22:28 -0500
Date: Tue, 4 Dec 2007 10:21:22 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	Holger Schurig <hs4233@mail.mn-solutions.de>,
	libertas-dev@lists.infradead.org
Subject: Re: [PATCH] less eventcause shifts
Message-ID: <20071204152122.GE19911@tuxdriver.com> (sfid-20071204_152231_199616_07AACB0C)
References: <200711280915.11300.hs4233@mail.mn-solutions.de> <1196704681.21151.13.camel@localhost.localdomain> <1196714939.13978.171.camel@pmac.infradead.org> <20071204145437.GC19911@tuxdriver.com> <1196780866.13978.275.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1196780866.13978.275.camel@pmac.infradead.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 04, 2007 at 03:07:46PM +0000, David Woodhouse wrote:
> On Tue, 2007-12-04 at 09:54 -0500, John W. Linville wrote:
> > The result is a nice, rebased set of patches on top of the current
> > upstream work.	If you simply did a "commit, pull, commit, pull,
> > etc" cycle then you would end-up with a set of patches that might
> > no longer apply on top of a clean upstream branch -- been there,
> > wireless-dev RIP.
> 
> Ah, I understand your confusion. It reflects akpm's confusion when he
> first started trying to use git-bisect.
> 
> This thing is, there is no actual need for a 'set of patches'. Git isn't
> about patches. It's about commits and pulls. It doesn't _matter_ if you
> had to fix up something when you merged from Linus, because when Linus
> pulls from your tree, he pulls your manual merge effort too.

Well I'm a bit hemmed-in -- Linus pull's from Dave and Jeff, they
pull from me.  Both of them are a bit prone to rebasing as well.
Even if I just "let it ride" (i.e. didn't rebase), I would still be
prone to some of the merge difficulties I described when I pulled
duplicate patches back in from Linus later.

FWIW, I've seen Linus complain about dirty git history on several
occassions.  So even if he were pulling directly from me I imagine
that there would still be a need for some of this quilt-like use of
git to clean-up things from time to time.

Still, it is true that I might be able to maintain a more consistent
'everything' branch if I weren't "serving two masters"...alas.

> > [1] If your work does _not_ rely on patches already merged in my tree
> > then by all means just use Linus' tree.
> 
> That was my intention, right up to the point at which a bunch of
> libertas patches appeared in your tree :)

It was my understanding that you were working on top of these patches
anyway (i.e. not rewriting or replacing them).  Anyway they are all
destined for 2.6.25 so your "Linus + libertas patches" just still be
just as valid...?

John
-- 
John W. Linville
linville@tuxdriver.com

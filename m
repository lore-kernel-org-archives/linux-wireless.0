Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40115 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802Ab0I1NOh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Sep 2010 09:14:37 -0400
Date: Tue, 28 Sep 2010 09:09:57 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <liville@tuxdriver.com>
Subject: Re: [PATCH] MAINTAINERS: Update git url for the wl1271 driver
Message-ID: <20100928130956.GC2440@tuxdriver.com>
References: <1285665597-31547-1-git-send-email-luciano.coelho@nokia.com>
 <1285666039.28270.54.camel@chilepepper>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1285666039.28270.54.camel@chilepepper>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 28, 2010 at 12:27:19PM +0300, Luciano Coelho wrote:
> On Tue, 2010-09-28 at 11:19 +0200, Coelho Luciano (Nokia-MS/Helsinki)
> wrote:
> > We are integrating wl1271 commits via a new git tree now and wl1271
> > development should be made on top of the new tree.
> > 
> > Update the repository url accordingly.
> > 
> > Cc: John W. Linville <liville@tuxdriver.com>
> > Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
> > ---
> >  MAINTAINERS |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 6cb1c75..a130d9f 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -6321,7 +6321,7 @@ WL1271 WIRELESS DRIVER
> >  M:	Luciano Coelho <luciano.coelho@nokia.com>
> >  L:	linux-wireless@vger.kernel.org
> >  W:	http://wireless.kernel.org
> > -T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git
> > +T:	git://git.kernel.org/pub/scm/linux/kernel/git/luca/wl12xx.git
> >  S:	Maintained
> >  F:	drivers/net/wireless/wl12xx/wl1271*
> >  F:	include/linux/wl12xx.h
> 
> John, should you apply this directly or should this go via the wl12xx
> tree?

Either seems fine to me.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46323 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709Ab0CZN2h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Mar 2010 09:28:37 -0400
Date: Fri, 26 Mar 2010 09:26:32 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 00/24] wl1271: bunch of patches from our internal tree
 wk12
Message-ID: <20100326132632.GD15128@tuxdriver.com>
References: <1269600813-32145-1-git-send-email-luciano.coelho@nokia.com>
 <20100326130215.GA15128@tuxdriver.com>
 <1269609195.22348.13.camel@powerslave>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1269609195.22348.13.camel@powerslave>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 26, 2010 at 03:13:15PM +0200, Luciano Coelho wrote:
> On Fri, 2010-03-26 at 14:02 +0100, ext John W. Linville wrote:
> > On Fri, Mar 26, 2010 at 12:53:09PM +0200, Luciano Coelho wrote:
> > 
> > > Here are 25 more patches for wl1271 which are still pending in our internal
> > > tree.  Please apply. :)
> > 
> > Are we catching-up?  Or will these dumps continue indefinitely?
> 
> Now we have finally caught up! Sorry for the mess, but we haven't been
> sending patches for a while and they really got delayed.
> 
> The idea from now on is to send them weekly (still in patch-sets), but
> not so many at once.  We review and test our patches internally before
> sending upstream, that's why we have to send them in batches.

Apparently Nokia, Intel, and maybe Atheros need to form some sort of
support group -- Patch-hoarder's Anonymous... :-)

> I'm currently reconsidering this process and trying to figure out how we
> can do things in a simpler way.  We are already doing all our mac80211
> work upstream, but for the driver we haven't found a good solution yet.
> 
> Would you prefer to pull stuff from a git tree instead of applying the
> patches?

It doesn't make a great deal of difference to me.  I have been pulling
from Intel for a little while now, and that has worked-out fairly
well from my perspective.  But, applying patchbombs is usually easy
so long as there hasn't been lots of other activity in the driver.
So, whatever is convenient for you is probably acceptable to me.

Hth!

John
-- 
John W. Linville                Someday the world will need a hero, and you
linville@tuxdriver.com                  might be all we have.  Be ready.

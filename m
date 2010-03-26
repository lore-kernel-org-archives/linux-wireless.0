Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:45470 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448Ab0CZNhr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Mar 2010 09:37:47 -0400
Subject: Re: [PATCH 00/24] wl1271: bunch of patches from our internal tree
 wk12
From: Luciano Coelho <luciano.coelho@nokia.com>
To: "ext John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20100326132632.GD15128@tuxdriver.com>
References: <1269600813-32145-1-git-send-email-luciano.coelho@nokia.com>
	 <20100326130215.GA15128@tuxdriver.com>
	 <1269609195.22348.13.camel@powerslave>
	 <20100326132632.GD15128@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Mar 2010 15:37:13 +0200
Message-ID: <1269610633.22348.29.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-03-26 at 14:26 +0100, ext John W. Linville wrote:
> On Fri, Mar 26, 2010 at 03:13:15PM +0200, Luciano Coelho wrote:
> > On Fri, 2010-03-26 at 14:02 +0100, ext John W. Linville wrote:
> > > On Fri, Mar 26, 2010 at 12:53:09PM +0200, Luciano Coelho wrote:
> > > 
> > > > Here are 25 more patches for wl1271 which are still pending in our internal
> > > > tree.  Please apply. :)
> > > 
> > > Are we catching-up?  Or will these dumps continue indefinitely?
> > 
> > Now we have finally caught up! Sorry for the mess, but we haven't been
> > sending patches for a while and they really got delayed.
> > 
> > The idea from now on is to send them weekly (still in patch-sets), but
> > not so many at once.  We review and test our patches internally before
> > sending upstream, that's why we have to send them in batches.
> 
> Apparently Nokia, Intel, and maybe Atheros need to form some sort of
> support group -- Patch-hoarder's Anonymous... :-)

LOL!


> > I'm currently reconsidering this process and trying to figure out how we
> > can do things in a simpler way.  We are already doing all our mac80211
> > work upstream, but for the driver we haven't found a good solution yet.
> > 
> > Would you prefer to pull stuff from a git tree instead of applying the
> > patches?
> 
> It doesn't make a great deal of difference to me.  I have been pulling
> from Intel for a little while now, and that has worked-out fairly
> well from my perspective.  But, applying patchbombs is usually easy
> so long as there hasn't been lots of other activity in the driver.
> So, whatever is convenient for you is probably acceptable to me.

Good that this hasn't been causing too much extra work for you.  If you
have any trouble applying the patches I send, just let me know and I'll
fix it.

I think the main drawback of sending patchbombs is that we don't get
good reviews from the community.  Nobody wants to dig into a so many
patches at once, so it would probably be much better to have the patches
sent one-by-one (or in relevant sets).  Unfortunately, we still have
many internal rounds before we're satisfied with the patches.  But I'll
see if we can change that.

Tfyh! :)


-- 
Cheers,
Luca.


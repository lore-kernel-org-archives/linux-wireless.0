Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:51271 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750903AbaAYAJf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jan 2014 19:09:35 -0500
Date: Fri, 24 Jan 2014 16:09:29 -0800
From: Tony Lindgren <tony@atomide.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Sebastian Reichel <sre@ring0.de>, linux-wireless@vger.kernel.org,
	linux-omap@vger.kernel.org
Subject: Re: [PATCHv2 0/5] wl1251 device tree support
Message-ID: <20140125000929.GD25488@atomide.com> (sfid-20140125_010939_952419_62319C36)
References: <1382890469-25286-1-git-send-email-sre@debian.org>
 <1386289336-26704-1-git-send-email-sre@debian.org>
 <20140106225709.GA23070@earth.universe>
 <20140117014514.GA604@earth.universe>
 <20140117150127.GA15145@tuxdriver.com>
 <20140117174415.GG7993@atomide.com>
 <20140117192204.GB15145@tuxdriver.com>
 <20140118174705.GE7235@atomide.com>
 <20140124215321.GA25727@earth.universe>
 <20140124235656.GM4309@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140124235656.GM4309@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* John W. Linville <linville@tuxdriver.com> [140124 16:03]:
> On Fri, Jan 24, 2014 at 10:53:22PM +0100, Sebastian Reichel wrote:
> > On Sat, Jan 18, 2014 at 09:47:06AM -0800, Tony Lindgren wrote:
> > > [...]
> > > 
> > > The reason was for keeping things building and git bisect working.
> > > 
> > > I do have wl1251-pdata-signed as the base for branch
> > > omap-for-v3.14/omap3-board-removal. However the board removal was
> > > considered too early for v3.14, so that's been postponed. This is
> > > because people are still updating their systems to device tree
> > > based booting. So I can redo my omap-for-v3.14/omap3-board-removal
> > > against v3.14.
> > > 
> > > So if you want to, feel free to pick all the wl12xx patches to your
> > > wireless tree. AFAIK my omap-for-v3.14/omap3-board-removal is the
> > > only other user for those patches, and that I can redo that on
> > > v3.14.
> > > 
> > > So for the arch/arm/*omap* touching patches, feel free to add:
> > > 
> > > Acked-by: Tony Lindgren <tony@atomide.com>
> > 
> > Another ping. If this does not go into 3.14 via wireless tree
> > it will become complicated for 3.15 again.
> 
> It's too late for new networking features in 3.14.  Why wouldn't Tony
> send it via his tree?

It's mostly drivers/net/wireless related to patch the wl12xx driver
further.
 
> At any rate, I don't have the patches.  If you still want them through
> the wireless tree (for 3.15) then you'll need to resend them.

Sebastian, please resend the whole series to John and feel free
to add my acks. It's best that John picks them all up, otherwise
we'll have the same issue for v3.15. It seems that we should have
just taken the merge conflict rather than going back and forth
with this.

Cheers,

Tony

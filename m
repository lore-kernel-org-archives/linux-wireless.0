Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48631 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbaAYAAz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jan 2014 19:00:55 -0500
Date: Fri, 24 Jan 2014 18:56:57 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Sebastian Reichel <sre@ring0.de>
Cc: Tony Lindgren <tony@atomide.com>, linux-wireless@vger.kernel.org,
	linux-omap@vger.kernel.org
Subject: Re: [PATCHv2 0/5] wl1251 device tree support
Message-ID: <20140124235656.GM4309@tuxdriver.com> (sfid-20140125_010100_244026_F6BA0887)
References: <1382890469-25286-1-git-send-email-sre@debian.org>
 <1386289336-26704-1-git-send-email-sre@debian.org>
 <20140106225709.GA23070@earth.universe>
 <20140117014514.GA604@earth.universe>
 <20140117150127.GA15145@tuxdriver.com>
 <20140117174415.GG7993@atomide.com>
 <20140117192204.GB15145@tuxdriver.com>
 <20140118174705.GE7235@atomide.com>
 <20140124215321.GA25727@earth.universe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140124215321.GA25727@earth.universe>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 24, 2014 at 10:53:22PM +0100, Sebastian Reichel wrote:
> On Sat, Jan 18, 2014 at 09:47:06AM -0800, Tony Lindgren wrote:
> > [...]
> > 
> > The reason was for keeping things building and git bisect working.
> > 
> > I do have wl1251-pdata-signed as the base for branch
> > omap-for-v3.14/omap3-board-removal. However the board removal was
> > considered too early for v3.14, so that's been postponed. This is
> > because people are still updating their systems to device tree
> > based booting. So I can redo my omap-for-v3.14/omap3-board-removal
> > against v3.14.
> > 
> > So if you want to, feel free to pick all the wl12xx patches to your
> > wireless tree. AFAIK my omap-for-v3.14/omap3-board-removal is the
> > only other user for those patches, and that I can redo that on
> > v3.14.
> > 
> > So for the arch/arm/*omap* touching patches, feel free to add:
> > 
> > Acked-by: Tony Lindgren <tony@atomide.com>
> 
> Another ping. If this does not go into 3.14 via wireless tree
> it will become complicated for 3.15 again.

It's too late for new networking features in 3.14.  Why wouldn't Tony
send it via his tree?

At any rate, I don't have the patches.  If you still want them through
the wireless tree (for 3.15) then you'll need to resend them.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

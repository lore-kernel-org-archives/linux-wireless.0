Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50498 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222AbYIGCCZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Sep 2008 22:02:25 -0400
Date: Sat, 6 Sep 2008 14:44:08 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Tim Gardner <tim.gardner@canonical.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] b43legacy: Fix failure in rate-adjustment mechanism
Message-ID: <20080906184408.GA2923@tuxdriver.com> (sfid-20080907_040255_674933_AA4ED665)
References: <48c2cd1a.pA60sTEK0WsW6wtt%Larry.Finger@lwfinger.net> <200809062041.06035.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200809062041.06035.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Sep 06, 2008 at 08:41:05PM +0200, Michael Buesch wrote:
> On Saturday 06 September 2008 20:34:02 Larry Finger wrote:
> > A coding error present since b43legacy was incorporated into the
> > kernel has prevented the driver from using the rate-setting mechanism
> > of mac80211. The driver has been forced to remain at a 1 Mb/s rate.
> 
> Does version3 firmware have a different bitlayout for the status?
> 
> > Although this is not strictly a regression, it is a bug. I hope
> > it can be sent to 2.6.27.
> 
> The new rules don't allow us to fix bugs after the merge window.
> Only regressions.

I imagine the powers that be would claim it isn't a new rule, but it
is a new enforcement policy...

John

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:54810 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbZAECjP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Jan 2009 21:39:15 -0500
Date: Mon, 5 Jan 2009 03:53:02 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Andi Kleen <andi@firstfloor.org>, Michael Buesch <mb@bu3sch.de>,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Subject: Re: rate instability in wireless stack
Message-ID: <20090105025302.GF496@one.firstfloor.org> (sfid-20090105_033918_513540_32130ACB)
References: <20090104164649.GV496@one.firstfloor.org> <200901041736.47650.mb@bu3sch.de> <20090104174123.GW496@one.firstfloor.org> <49615465.4090604@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <49615465.4090604@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 04, 2009 at 06:29:25PM -0600, Larry Finger wrote:
> Andi,
> 
> Andi Kleen wrote:
> > 
> > Anyways with PID i get between 1Mbit/s and 5.5Mbit/s, most of the
> > time 1Mbit/s. So it's not really much better.
> 
> 
> Does this patch help? Recently mac80211 changed from expecting tries
> to retries, and I don't think rtl8180 got changed.

Same issue with this patch. It fluctuates some time between 11Mbit/s
and 48Mbit/s, but then eventually settles on 1Mbit/s again. That's with PID
now, not Mistrel. I think it takes longer with this patch than
before, but not much.

BTW I see the problem with RT2561 too.

-Andi

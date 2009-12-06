Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:51034 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934014AbZLFRc2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Dec 2009 12:32:28 -0500
Date: Sun, 6 Dec 2009 18:32:34 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Andi Kleen <andi@firstfloor.org>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Tim Blechmann <tim@klingt.org>, rjw@sisk.pl, IvDoorn@gmail.com,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: regression: rt2561 frequent "Arrived at non-free entry" errors in	2.6.32
Message-ID: <20091206173234.GW18989@one.firstfloor.org>
References: <20091204233202.GA13658@basil.fritz.box> <4B1BB44E.90706@gmail.com> <20091206170401.GV18989@one.firstfloor.org> <1260120057.3461.18.camel@johannes.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1260120057.3461.18.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Dec 06, 2009 at 06:20:57PM +0100, Johannes Berg wrote:
> On Sun, 2009-12-06 at 18:04 +0100, Andi Kleen wrote:
> > > Both of you have reported this problem on 2.6.32.
> > 
> > For me it seems like the problem went away since I disabled
> > CONFIG_CFG80211_DEFAULT_PS (that would indicate it's related
> > to power saving?) 
> 
> FWIW, 'iwconfig wlan0 power on/off' is an easier way to change that than
> recompiling your kernel.

I wasn't sure if they are equivalent. This stuff is all quite under
documented and I gave up tracing the code paths at some point.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

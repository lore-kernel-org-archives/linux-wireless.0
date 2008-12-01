Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:31068 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752269AbYLAXto (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 18:49:44 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 01 Dec 2008 15:49:44 -0800
Date: Mon, 1 Dec 2008 15:49:42 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Kalle Valo <kalle.valo@nokia.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC v3 2/4] mac80211: implement dynamic power save
Message-ID: <20081201234941.GT5992@tesla> (sfid-20081202_004948_510419_8114D029)
References: <1227901784-5325-1-git-send-email-kalle.valo@nokia.com> <1227901784-5325-3-git-send-email-kalle.valo@nokia.com> <43e72e890812011110o4aeb8334k6702f64a1867e1f7@mail.gmail.com> <1228171242.10627.48.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1228171242.10627.48.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 01, 2008 at 02:40:41PM -0800, Johannes Berg wrote:
> On Mon, 2008-12-01 at 11:10 -0800, Luis R. Rodriguez wrote:
> 
> > Might be worth noting that when dynamic power save is enabled for
> > mac80211 that this will only work right now for devices which handle
> > power save in firmware as power save is not yet implemented in
> > mac80211.
> 
> Power save mode inherently is a feature that needs to be implemented on
> the chip due to timing requirements, what else are you looking for in
> mac80211? mac80211 tells the chip "it's ok to enter PS mode now" via the
> hw conf callback, that's pretty much all it can do.

Well the stuff vivek is adding.

  Luis

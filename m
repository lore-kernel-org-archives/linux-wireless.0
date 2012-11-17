Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56496 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110Ab2KQJcf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Nov 2012 04:32:35 -0500
Message-ID: <1353144789.9543.33.camel@jlt4.sipsolutions.net> (sfid-20121117_103239_568135_C71245E1)
Subject: Re: [RFC 13/14] mac80211: add TIM IE to mesh beacons
From: Johannes Berg <johannes@sipsolutions.net>
To: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Cc: javier@cozybit.com, linux-wireless@vger.kernel.org
Date: Sat, 17 Nov 2012 10:33:09 +0100
In-Reply-To: <1353134886-13256-14-git-send-email-marco.porsch@etit.tu-chemnitz.de>
References: <1353134886-13256-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
	 <1353134886-13256-14-git-send-email-marco.porsch@etit.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-11-16 at 22:48 -0800, Marco Porsch wrote:
> Create a TIM IE similarly to AP mode and add it to mesh beacons.
> Use the peer's link ID instead of the access point's association ID.
> 
> Since the TIM map only supports announcing buffered frames for
> IEEE80211_MAX_AID STA (2007), we mod down our mesh LLID/PLID to fit.

This comment seems misplaced, no such thing is happening in this patch?

johannes


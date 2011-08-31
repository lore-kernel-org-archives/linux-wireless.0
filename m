Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56585 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754561Ab1HaHkD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 03:40:03 -0400
Subject: Re: [PATCH] nl80211/cfg80211: add ssid filtering for sched_scan
From: Johannes Berg <johannes@sipsolutions.net>
To: Luciano Coelho <coelho@ti.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1314775816.2296.531.camel@cumari>
References: <1314707979-26484-1-git-send-email-coelho@ti.com>
	 <1314713812.4011.33.camel@jlt3.sipsolutions.net>
	 <1314718038.2296.460.camel@cumari>
	 <1314720557.4011.41.camel@jlt3.sipsolutions.net>
	 <1314770941.2296.507.camel@cumari>
	 <1314771627.4161.9.camel@jlt3.sipsolutions.net>
	 <1314775816.2296.531.camel@cumari>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 31 Aug 2011 09:39:56 +0200
Message-ID: <1314776396.4161.19.camel@jlt3.sipsolutions.net> (sfid-20110831_094007_170723_62899827)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-08-31 at 10:30 +0300, Luciano Coelho wrote:

> > Ok. I think the BSSID blacklist would just be a separate attribute, I
> > see no reason to have a nesting for that.
> 
> Actually, we could make the filter and blacklisting very generic.  We
> can use the same attributes for both.  The only difference would be that
> the former would include anything that matches and the latter would
> exclude anything that matches.

Hm, true, but does it really make sense to blacklist SSIDs when we have
a whitelist for them? Or would you want to whitelist a wildcard and then
blacklist a specific one?


> I also prefer using match/not_match (couldn't find a better antonym),
> because "filter" is ambiguous (let-through or leave-out?).

agree.

johannes


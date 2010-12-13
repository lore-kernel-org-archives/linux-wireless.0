Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:20680 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374Ab0LMP2b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Dec 2010 10:28:31 -0500
Subject: Re: [RFC v2 1/2] cfg80211/nl80211: add support for scheduled scans
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1292011514.3531.19.camel@jlt3.sipsolutions.net>
References: <1291993632-6921-1-git-send-email-luciano.coelho@nokia.com>
	 <1291993632-6921-2-git-send-email-luciano.coelho@nokia.com>
	 <1292011514.3531.19.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Dec 2010 17:30:02 +0200
Message-ID: <1292254202.2951.257.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-12-10 at 21:05 +0100, ext Johannes Berg wrote:
> On Fri, 2010-12-10 at 17:07 +0200, luciano.coelho@nokia.com wrote:
> 
> > Add NL80211_CMD_START_SCHED_SCAN and NL80211_CMD_STOP_SCHED_SCAN
> > commands to the nl80211 interface.  When results are available they are
> > reported by NL80211_CMD_SCHED_SCAN_RESULTS events.
> 
> Oh, also, I think you should check the wiphy flag in the commands,
> because otherwise somebody will invariably end up writing a driver that
> doesn't set the flag, but still expect it to be working :-)

Done.  It's a good idea to be extra-careful with driver implementations.

-- 
Cheers,
Luca.


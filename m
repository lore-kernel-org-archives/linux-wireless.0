Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40351 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758512Ab2CFIcs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2012 03:32:48 -0500
Subject: Re: WARNING: driver-ops.h:10 -- how do I fix this?
From: Johannes Berg <johannes@sipsolutions.net>
To: Bryan Phillippe <Bryan.Phillippe@watchguard.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <461155E6-5B2C-48C3-AD1C-4D07B6EECE4B@watchguard.com> (sfid-20120306_014028_944755_47BCD942)
References: <461155E6-5B2C-48C3-AD1C-4D07B6EECE4B@watchguard.com>
	 (sfid-20120306_014028_944755_47BCD942)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Mar 2012 09:32:46 +0100
Message-ID: <1331022766.3447.4.camel@jlt3.sipsolutions.net> (sfid-20120306_093251_482549_32ECEBD3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-03-06 at 00:40 +0000, Bryan Phillippe wrote:
> on compat-wireless-2012-02-06 as well as compat-wireless-3.3-rc1-2, I see this:
> 
> WARNING: at ath9k/net/mac80211/driver-ops.h:10 ieee80211_bss_info_change_notify+0x150/0x18c [mac80211]()
> 
> any time I change from one band to another.  How do I fix this?

Post the full warning and then we can see if we can figure it out.

johannes


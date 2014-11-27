Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35521 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077AbaK0Qjg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Nov 2014 11:39:36 -0500
Message-ID: <1417106373.32668.2.camel@sipsolutions.net> (sfid-20141127_173940_567061_5D7E1731)
Subject: Re: [PATCH 3.18] mac80211: copy chandef from AP vif to VLANs
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 27 Nov 2014 17:39:33 +0100
In-Reply-To: <1416849136-14507-1-git-send-email-nbd@openwrt.org> (sfid-20141124_181230_833710_DB28BB93)
References: <1416849136-14507-1-git-send-email-nbd@openwrt.org>
	 (sfid-20141124_181230_833710_DB28BB93)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-11-24 at 18:12 +0100, Felix Fietkau wrote:
> Fixes a crash in nl80211_send_chandef, introduced in
> 
> commit c12bc4885f4b3bab0ed779c69d5d7e3223fa5003
> "mac80211: return the vif's chandef in ieee80211_cfg_get_channel()"

I've fixed up the commit log myself and applied it, but I doubt we'll
get it into 3.18 at this point, so I've applied it to mac80211-next with
the stable tag.

johannes


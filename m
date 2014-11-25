Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50082 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828AbaKYKHL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2014 05:07:11 -0500
Message-ID: <1416910024.2045.0.camel@sipsolutions.net> (sfid-20141125_110715_804019_3EEB1663)
Subject: Re: [PATCH 3.18] mac80211: copy chandef from AP vif to VLANs
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 25 Nov 2014 11:07:04 +0100
In-Reply-To: <1416849136-14507-1-git-send-email-nbd@openwrt.org>
References: <1416849136-14507-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-11-24 at 18:12 +0100, Felix Fietkau wrote:
> Fixes a crash in nl80211_send_chandef, introduced in
> 
> commit c12bc4885f4b3bab0ed779c69d5d7e3223fa5003
> "mac80211: return the vif's chandef in ieee80211_cfg_get_channel()"

I think you should explain this a bit more.

Code looks fine - maybe we can even have a follow-up patch that removes
some special cases for VLAN?

johannes


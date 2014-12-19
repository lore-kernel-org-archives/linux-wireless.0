Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48205 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751165AbaLSUeq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Dec 2014 15:34:46 -0500
Message-ID: <1419021281.1889.7.camel@sipsolutions.net> (sfid-20141219_213449_349361_36ADDA64)
Subject: Re: [PATCH v2 3.19] mac80211: minstrel: reduce size of struct
 minstrel_rate_stats
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 19 Dec 2014 21:34:41 +0100
In-Reply-To: <1418819914-9535-1-git-send-email-nbd@openwrt.org>
References: <1418819914-9535-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-12-17 at 13:38 +0100, Felix Fietkau wrote:
> On minstrel_ht, the size of the per-sta struct is almost 18k, making it
> an order-3 allocation.
> A few fields inside the per-rate statistics are bigger than they need to
> be. This patch reduces the size enough to cut down the per-sta struct to
> about 13k (order-2 allocation).

Applied to mac80211-next.

johannes


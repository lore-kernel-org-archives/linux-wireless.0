Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40296 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754781AbaKSSeZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2014 13:34:25 -0500
Message-ID: <1416422062.9374.20.camel@sipsolutions.net> (sfid-20141119_193428_525681_B844AD8C)
Subject: Re: [PATCH 1/6] mac80211: minstrel_ht: add a small optimization to
 minstrel_aggr_check
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 19 Nov 2014 19:34:22 +0100
In-Reply-To: <1416094080-49220-1-git-send-email-nbd@openwrt.org>
References: <1416094080-49220-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2014-11-16 at 00:27 +0100, Felix Fietkau wrote:
> Check the queue mapping earlier, skb->queue_mapping is more likely than
> skb->data to still be in d-cache.

Applied.

johannes


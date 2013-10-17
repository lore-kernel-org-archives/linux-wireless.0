Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:44035 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756779Ab3JQOh3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Oct 2013 10:37:29 -0400
Message-ID: <1382020646.14410.13.camel@jlt4.sipsolutions.net> (sfid-20131017_163831_102512_B2BA2B5D)
Subject: Re: [PATCH] mac80211: add ieee80211_tx_prepare_skb() helper function
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 17 Oct 2013 16:37:26 +0200
In-Reply-To: <1381766460-84515-1-git-send-email-nbd@openwrt.org>
References: <1381766460-84515-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-10-14 at 18:01 +0200, Felix Fietkau wrote:
> This can be used by a driver to prepare skbs for transmission, which were
> obtained via functions such as ieee80211_probereq_get or
> ieee80211_nullfunc_get.
> 
> This is useful for drivers that want to send those frames directly, but
> need rate control information to be prepared first.

Applied.

johannes


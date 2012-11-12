Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36032 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073Ab2KLIj7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Nov 2012 03:39:59 -0500
Message-ID: <1352709631.9525.0.camel@jlt4.sipsolutions.net> (sfid-20121112_094003_847469_D0906891)
Subject: Re: [PATCH 3.7] mac80211: call skb_dequeue/ieee80211_free_txskb
 instead of __skb_queue_purge
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 12 Nov 2012 09:40:31 +0100
In-Reply-To: <1352515454-21067-1-git-send-email-nbd@openwrt.org>
References: <1352515454-21067-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2012-11-10 at 03:44 +0100, Felix Fietkau wrote:
> Fixes more wifi status skb leaks, leading to hostapd/wpa_supplicant hangs.
> 
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> Cc: stable@vger.kernel.org

Applied, thanks.

johannes


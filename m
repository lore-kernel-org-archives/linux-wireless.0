Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49403 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756159Ab2JKJih (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Oct 2012 05:38:37 -0400
Message-ID: <1349948350.13097.2.camel@jlt4.sipsolutions.net> (sfid-20121011_113841_417344_C76834EC)
Subject: Re: [PATCH 3.7] mac80211: use ieee80211_free_txskb in a few more
 places
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Date: Thu, 11 Oct 2012 11:39:10 +0200
In-Reply-To: <1349901623-63864-1-git-send-email-nbd@openwrt.org>
References: <1349901623-63864-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-10-10 at 22:40 +0200, Felix Fietkau wrote:
> Free tx status skbs when draining power save buffers, pending frames, or
> when tearing down a vif.
> Fixes remaining conditions that can lead to hostapd/wpa_supplicant hangs when
> running out of socket write memory.

Looks fine. FWIW, I think in your first patch you converted too many
places, but it doesn't matter and is probably more forward compatible :)

johannes


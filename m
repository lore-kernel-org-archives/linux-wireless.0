Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50696 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932636Ab3BMJ50 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2013 04:57:26 -0500
Message-ID: <1360749441.8868.8.camel@jlt4.sipsolutions.net> (sfid-20130213_105730_705573_A1CA5CA6)
Subject: Re: [PATCH v4] mac80211/minstrel_ht: add support for using CCK rates
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 13 Feb 2013 10:57:21 +0100
In-Reply-To: <1360749068-3977-1-git-send-email-nbd@openwrt.org>
References: <1360749068-3977-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-02-13 at 10:51 +0100, Felix Fietkau wrote:
> When MCS rates start to get bad in 2.4 GHz because of long range or
> strong interference, CCK rates can be a lot more robust.
> 
> This patch adds a pseudo MCS group containing CCK rates (long preamble
> in the lower 4 slots, short preamble in the upper slots).

Applied, I made minstrel_ht_get_stats static.

johannes


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42077 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756459Ab3CDPIB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 10:08:01 -0500
Message-ID: <1362409677.21028.14.camel@jlt4.sipsolutions.net> (sfid-20130304_160805_134640_18364D42)
Subject: Re: [PATCH 1/2] mac80211/minstrel_ht: increase sampling frequency
 of some slower rates
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 04 Mar 2013 16:07:57 +0100
In-Reply-To: <1362311392-83648-1-git-send-email-nbd@openwrt.org>
References: <1362311392-83648-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2013-03-03 at 12:49 +0100, Felix Fietkau wrote:
> If a rate is below the max_tp_rate, sample it frequently if:
> - it is above max_tp_rate2, or
> - it is above max_prob_rate and is a candidate for max_prob_rate
>   (has fewer streams than max_tp_rate).
> This helps the retry chain recover more quickly from bad statistics
> caused by collisions or interference, and slightly reduces throughput
> fluctuations with higher rates.

Applied both.

johannes


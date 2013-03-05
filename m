Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46818 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843Ab3CEStI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Mar 2013 13:49:08 -0500
Message-ID: <1362509338.8224.3.camel@jlt4.sipsolutions.net> (sfid-20130305_194913_681733_66D7198F)
Subject: Re: [PATCH] mac80211/minstrel_ht: disable multiple consecutive
 sample attempts
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 05 Mar 2013 19:48:58 +0100
In-Reply-To: <1362489619-75636-1-git-send-email-nbd@openwrt.org>
References: <1362489619-75636-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-03-05 at 14:20 +0100, Felix Fietkau wrote:
> The last minstrel_ht changes increased the sampling frequency for
> potentially useful rates to decrease the response time to rate
> fluctuations. This caused an increase in sampling frequency that can
> slightly reduce throughput, so this patch limits the sampling attempts
> to one per rate instead of two.

Applied.

johannes


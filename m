Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47690 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757815Ab3BZUxX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Feb 2013 15:53:23 -0500
Message-ID: <1361911998.8440.19.camel@jlt4.sipsolutions.net> (sfid-20130226_215326_611422_4EA71E16)
Subject: Re: [PATCH 3.9] mac80211: fix idle handling in monitor mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 26 Feb 2013 21:53:18 +0100
In-Reply-To: <1361641257-26963-1-git-send-email-nbd@openwrt.org>
References: <1361641257-26963-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2013-02-23 at 18:40 +0100, Felix Fietkau wrote:
> When the driver does not want a monitor mode VIF, no channel context is
> allocated for it. This causes ieee80211_recalc_idle to put the hardware
> into idle mode if only a monitor mode is active, breaking injection.
> 
> Fix this by checking local->monitors in addition to active channel
> contexts.

Applied.

johannes


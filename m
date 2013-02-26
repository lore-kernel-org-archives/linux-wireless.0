Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47693 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758026Ab3BZUyJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Feb 2013 15:54:09 -0500
Message-ID: <1361912044.8440.20.camel@jlt4.sipsolutions.net> (sfid-20130226_215412_927833_59E1468F)
Subject: Re: [PATCH 3.9] mac80211: fix monitor mode channel reporting
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 26 Feb 2013 21:54:04 +0100
In-Reply-To: <1361642534-39566-1-git-send-email-nbd@openwrt.org>
References: <1361642534-39566-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2013-02-23 at 19:02 +0100, Felix Fietkau wrote:
> When not using channel contexts with only monitor mode interfaces being
> active, report local->monitor_chandef to userspace.

Makes sense, applied.

johannes


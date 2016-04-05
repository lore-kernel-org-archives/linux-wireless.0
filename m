Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53574 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756613AbcDEJk1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2016 05:40:27 -0400
Message-ID: <1459849223.18188.27.camel@sipsolutions.net> (sfid-20160405_114030_354749_483B3087)
Subject: Re: [PATCH] mac80211: minstrel_ht: improve sample rate skip logic
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org
Date: Tue, 05 Apr 2016 11:40:23 +0200
In-Reply-To: <1457043942-88115-1-git-send-email-nbd@openwrt.org>
References: <1457043942-88115-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-03-03 at 23:25 +0100, Felix Fietkau wrote:
> There were a few issues that were slowing down the process of finding
> the optimal rate, especially on devices with multi-rate retry
> limitations:
> 
[...]

applied.

johannes

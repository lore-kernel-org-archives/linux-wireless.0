Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:44729 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460Ab3GCISs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jul 2013 04:18:48 -0400
Message-ID: <1372839522.9213.1.camel@jlt4.sipsolutions.net> (sfid-20130703_101853_106278_1D45B814)
Subject: Re: [PATCH] mac80211/minstrel_ht: fix cck rate sampling
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 03 Jul 2013 10:18:42 +0200
In-Reply-To: <1372446275-43012-1-git-send-email-nbd@openwrt.org>
References: <1372446275-43012-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-06-28 at 21:04 +0200, Felix Fietkau wrote:
> The CCK group needs special treatment to set the right flags and rate
> index. Add this missing check to prevent setting broken rates for tx
> packets.

Applied.

johannes


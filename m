Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53280 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935534Ab3DPOVG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Apr 2013 10:21:06 -0400
Message-ID: <1366122059.8244.27.camel@jlt4.sipsolutions.net> (sfid-20130416_162111_926535_97914008)
Subject: Re: [PATCH v2 2/5] mac80211: fix CTS protection handling
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, karl.beldan@gmail.com
Date: Tue, 16 Apr 2013 16:20:59 +0200
In-Reply-To: <1366112326-92981-2-git-send-email-nbd@openwrt.org>
References: <1366112326-92981-1-git-send-email-nbd@openwrt.org>
	 <1366112326-92981-2-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-04-16 at 13:38 +0200, Felix Fietkau wrote:
> The rates[0] CTS and RTS flags are only set after rate control has been
> called, so minstrel cannot use them to for setting the number of
> retries. This patch adds two new flags to explicitly indicate RTS/CTS use.

I applied patches 1 and 2, and while 2 had a conflict I could resolve
easily I don't trust myself to fix the conflicts in patch 3 correctly...

It's conflicting with Karl's VHT handling fix in this area that I just
applied.

johannes


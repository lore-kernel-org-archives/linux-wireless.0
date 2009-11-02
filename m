Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:64013 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754241AbZKBKjz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2009 05:39:55 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2009 02:40:01 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19182.46968.176623.303221@gargle.gargle.HOWL>
Date: Mon, 2 Nov 2009 16:12:00 +0530
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: fix internal scan request
In-Reply-To: <1257157911.3555.183.camel@johannes.local>
References: <1257157911.3555.183.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> The internal scan request mac80211 uses to
> scan for IBSS networks was set up to contain
> no channels at all because n_channels wasn't
> set after setting up the channels array. Fix
> this to properly scan for networks.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
> Sujith, this might fix the iwlwifi problem?
> 

Yep, it fixes the oops.
Thanks.

Sujith

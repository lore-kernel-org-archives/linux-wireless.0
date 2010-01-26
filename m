Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:53320 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238Ab0AZQlV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2010 11:41:21 -0500
Date: Tue, 26 Jan 2010 17:41:18 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, kalle.valo@iki.fi,
	linux-wireless@vger.kernel.org, j@w1.fi, wey-yi.w.guy@intel.com
Subject: Re: [PATCH] mac80211: wait for beacon before enabling powersave
Message-ID: <20100126164118.GM25367@mail.wantstofly.org>
References: <1264511993.25642.9.camel@johannes.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1264511993.25642.9.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 26, 2010 at 02:19:52PM +0100, Johannes Berg wrote:

> Because DTIM information is required for powersave
> but is only conveyed in beacons, wait for a beacon
> before enabling powersave, and change the way the
> information is conveyed to the driver accordingly.
> 
> mwl8k doesn't currently seem to implement PS but
> requires the DTIM period in a different way; after
> talking to Lennert we agreed to just have mwl8k do
> the parsing itself in the finalize_join work.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

Acked-by: Lennert Buytenhek <buytenh@marvell.com>

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40206 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754929AbaKSSQS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2014 13:16:18 -0500
Message-ID: <1416420975.9374.19.camel@sipsolutions.net> (sfid-20141119_191621_492929_A89AC889)
Subject: Re: [PATCH v2] mac80211: notify drivers on sta rate table changes
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 19 Nov 2014 19:16:15 +0100
In-Reply-To: <1416352242-66124-1-git-send-email-nbd@openwrt.org>
References: <1416352242-66124-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-11-19 at 00:10 +0100, Felix Fietkau wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> This allows drivers with a firmware or chip-based rate lookup table to
> use the most recent default rate selection without having to get it from
> per-packet data or explicit ieee80211_get_tx_rate calls

Applied.

johannes


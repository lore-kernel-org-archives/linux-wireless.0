Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47361
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754297AbYELJJV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 May 2008 05:09:21 -0400
Date: Mon, 12 May 2008 02:09:15 -0700 (PDT)
Message-Id: <20080512.020915.144609483.davem@davemloft.net> (sfid-20080512_110923_063027_3896BEAA)
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFT/C 1/7] mac80211: use skb_header_cloned()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080510221905.646038000@sipsolutions.net>
References: <20080510221845.340428000@sipsolutions.net>
	<20080510221905.646038000@sipsolutions.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Sun, 11 May 2008 00:18:46 +0200

> mac80211 doesn't need to care here about cloned status but rather
> about whether the skb header data area is modifiable.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

Acked-by: David S. Miller <davem@davemloft.net>

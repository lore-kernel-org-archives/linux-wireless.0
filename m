Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48060
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751277AbYC1Hrx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2008 03:47:53 -0400
Date: Fri, 28 Mar 2008 00:47:53 -0700 (PDT)
Message-Id: <20080328.004753.36505184.davem@davemloft.net> (sfid-20080328_074756_923528_CCFDCD12)
To: akpm@linux-foundation.org
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: ieee80211_get_channel exported twice
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080328004353.7ae30fe4.akpm@linux-foundation.org>
References: <20080328004353.7ae30fe4.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 28 Mar 2008 00:43:53 -0700

> 
> ia64 allmodconfig says:
> 
> WARNING: net/wireless/cfg80211: 'ieee80211_get_channel' exported twice. Previous export was in net/ieee80211/ieee80211.ko
> 
> net/ieee80211/ieee80211_geo.c already has an exported ieee80211_get_channel().
> 
> net-2.6.26 adds a new version of ieee80211_get_channel() in
> net/wireless/util.c and exports that as well.

It's fixed in the net-2.6.26 tree as of this afternoon.

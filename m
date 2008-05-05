Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50042
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1760812AbYEEVBD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 May 2008 17:01:03 -0400
Date: Mon, 05 May 2008 14:01:03 -0700 (PDT)
Message-Id: <20080505.140103.145523270.davem@davemloft.net> (sfid-20080505_230043_980433_36CC18B1)
To: johannes@sipsolutions.net
Cc: tomasw@gmail.com, linville@tuxdriver.com, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC v2] mac80211: assign needed_headroom/tailroom for netdevs
From: David Miller <davem@davemloft.net>
In-Reply-To: <1210021066.4181.41.camel@johannes.berg>
References: <1210018214.4181.27.camel@johannes.berg>
	<20080505.134420.194001886.davem@davemloft.net>
	<1210021066.4181.41.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Mon, 05 May 2008 22:57:46 +0200

> But I cannot modify the ethernet header that'll live on in the skb data
> so that's not useful. Also, if two mac80211 netdevs are bridged together
> they'd stomp on each other no?

I see, let me think about this for a while...

Thanks for the information.

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45761
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753321AbYEEXkU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 May 2008 19:40:20 -0400
Date: Mon, 05 May 2008 16:40:20 -0700 (PDT)
Message-Id: <20080505.164020.186462923.davem@davemloft.net> (sfid-20080506_013937_161867_EDCB8CDE)
To: johannes@sipsolutions.net
Cc: tomasw@gmail.com, linville@tuxdriver.com, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC v2] mac80211: assign needed_headroom/tailroom for netdevs
From: David Miller <davem@davemloft.net>
In-Reply-To: <1210030591.8012.41.camel@johannes.berg>
References: <1210000923.8245.26.camel@johannes.berg>
	<20080505.160328.203996832.davem@davemloft.net>
	<1210030591.8012.41.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Tue, 06 May 2008 01:36:31 +0200

> four-byte multiple isn't quite right though, but I'm not sure what would
> be, probably multiple of NET_SKB_PAD?

Yes, NET_SKB_PAD is what I was going to use.

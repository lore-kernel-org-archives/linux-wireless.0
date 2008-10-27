Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52695
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750744AbYJ0WxG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Oct 2008 18:53:06 -0400
Date: Mon, 27 Oct 2008 15:52:43 -0700 (PDT)
Message-Id: <20081027.155243.206513005.davem@davemloft.net> (sfid-20081027_235314_028800_0384586E)
To: johannes@sipsolutions.net
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
Subject: Re: [PATCH/RFC] mac80211: convert to %pM away from print_mac
From: David Miller <davem@davemloft.net>
In-Reply-To: <1224892243.3919.32.camel@johannes.berg>
References: <1224892243.3919.32.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Sat, 25 Oct 2008 01:50:43 +0200

> Also remove a few stray DECLARE_MAC_BUF that were no longer
> used at all.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
> Not sure this will apply to your tree, I prepared it against John's tree
> which might have more things. If you put the previous patch in, I
> suppose John _could_ put it into his tree, but then he'd have to pull in
> yours which he normally doesn't... No idea. I can also just postpone
> this?

I munged this to apply to my tree, the only conflicts were in
mlme.c

Sorry John, one of us had to deal with this :-)

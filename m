Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58796
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753072AbYHCJzH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Aug 2008 05:55:07 -0400
Date: Sun, 03 Aug 2008 02:55:07 -0700 (PDT)
Message-Id: <20080803.025507.213173770.davem@davemloft.net> (sfid-20080803_115511_885253_3D5C2B5D)
To: johannes@sipsolutions.net
Cc: jasper@amiton.co.nz, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] move ETH_P_PAE from ieee80211_i.h to if_ether.h
From: David Miller <davem@davemloft.net>
In-Reply-To: <1217755343.4721.11.camel@johannes.berg>
References: <1217719855.14226.5.camel@luna.unix.geek.nz>
	<1217755343.4721.11.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Sun, 03 Aug 2008 11:22:23 +0200

> On Sun, 2008-08-03 at 11:30 +1200, Jasper Bryant-Greene wrote:
> > ETH_P_PAE belongs in if_ether.h with the other ETH_P_* definitions. This
> > patch moves it there.
> 
> 
> This needs to cross netdev, but other than that
> 
> > Signed-off-by: Jasper Bryant-Greene <jasper@amiton.co.nz>
> 
> Acked-by: Johannes Berg <johannes@sipsolutions.net>

I'm fine with it, John can add it to his wireless tree and I'll
snag it from there next time he pushes to me.


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:60103 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbcA2AQ7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jan 2016 19:16:59 -0500
Date: Thu, 28 Jan 2016 16:16:57 -0800 (PST)
Message-Id: <20160128.161657.1850505368474577536.davem@davemloft.net> (sfid-20160129_011707_592332_1722761D)
To: johannes@sipsolutions.net
Cc: ja@ssi.bg, linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 1/4] ipv4: add option to drop unicast encapsulated
 in L2 multicast
From: David Miller <davem@davemloft.net>
In-Reply-To: <1453984413.2217.13.camel@sipsolutions.net>
References: <1446712923-9136-1-git-send-email-johannes@sipsolutions.net>
	<1453984413.2217.13.camel@sipsolutions.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Thu, 28 Jan 2016 13:33:33 +0100

> Is there anything I should do about these patches?
> 
> I see you marked them as "deferred" in patchwork, but I don't really
> know how you're using that state.

I use it in two situations, the first is the most often used case but
doesn't apply to this specific situation :-)

1) net-next change submitted while net-next is closed

2) discussion has ensued for several days, no resolution imminent

And I think #2 is the case that happened here.

You can submit them again to reignite the conversation if you
like.

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:59560 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbbDASUX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Apr 2015 14:20:23 -0400
Date: Wed, 01 Apr 2015 14:20:19 -0400 (EDT)
Message-Id: <20150401.142019.102151219462061481.davem@davemloft.net> (sfid-20150401_202031_421573_0C357621)
To: johannes@sipsolutions.net
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211 2015-04-01
From: David Miller <davem@davemloft.net>
In-Reply-To: <1427895969.3428.9.camel@sipsolutions.net>
References: <1427895969.3428.9.camel@sipsolutions.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Wed, 01 Apr 2015 15:46:09 +0200

> This morning I randomly ran into a kernel crash and then I looked into
> it and came up with this fix. It's clearly been around for quite a while
> without anyone having seen it before (to my knowledge), so if you think
> you don't want to pull it into net.git at this point that should be
> fine.
> 
> Let me know what you want to do with it, I can also put it into
> mac80211-next instead (although then Greg complains that he gets a lot
> of Cc stable patches in rc1, but all the processes need time ...).

Pulled, thanks Johannes.

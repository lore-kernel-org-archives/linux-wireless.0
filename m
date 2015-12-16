Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:41507 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732AbbLPXep (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Dec 2015 18:34:45 -0500
Date: Wed, 16 Dec 2015 18:34:43 -0500 (EST)
Message-Id: <20151216.183443.615368179590575650.davem@davemloft.net> (sfid-20151217_003452_655550_538852C6)
To: johannes@sipsolutions.net
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211 2015-12-15
From: David Miller <davem@davemloft.net>
In-Reply-To: <1450182621.3356.12.camel@sipsolutions.net>
References: <1450182621.3356.12.camel@sipsolutions.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Tue, 15 Dec 2015 13:30:21 +0100

> After going through my patch queue, I have another set of fixes that
> I think is still appropriate for the current cycle.
> 
> Two of my own restart changes there are fairly big but for the most
> part just move code around so it can be called in a slightly different
> order.
> 
> Let me know if there are any issues.

Something about your text encoding kept this from ending up
in patchwork for some reason.

Anyways, pulled, thanks a lot!

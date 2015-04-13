Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:48083 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbbDMAoR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Apr 2015 20:44:17 -0400
Date: Sun, 12 Apr 2015 20:44:15 -0400 (EDT)
Message-Id: <20150412.204415.314629315160918556.davem@davemloft.net> (sfid-20150413_024423_447617_0DD06647)
To: johannes@sipsolutions.net
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211-next 2015-04-10
From: David Miller <davem@davemloft.net>
In-Reply-To: <1428664738.1890.12.camel@sipsolutions.net>
References: <1428664738.1890.12.camel@sipsolutions.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Fri, 10 Apr 2015 13:18:58 +0200

> I realize it's late, but what I've got right now has so many fixes that
> I'd be sending even after the merge window, so it felt like there was
> little point in holding it up until after then. The new "intermediate
> queue" feature is unused right now so seems safe enough also, and having
> it in will help modify drivers to use it.
> There's also some rate control refactoring that, as far as I can tell,
> is uncontroversial and over the last couple of weeks has been has been
> reviewed and tested by people who use it, so I'm including it.
> 
> Let me know if you want me to change anything here or if there are any
> other problems.

Pulled, thanks Johannes.

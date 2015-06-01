Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:44200 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbbFAAff (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 May 2015 20:35:35 -0400
Date: Sun, 31 May 2015 17:35:34 -0700 (PDT)
Message-Id: <20150531.173534.725322474667007103.davem@davemloft.net> (sfid-20150601_023542_408438_1D75B6AF)
To: johannes@sipsolutions.net
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211-next 2015-05-29
From: David Miller <davem@davemloft.net>
In-Reply-To: <1432898714.2104.15.camel@sipsolutions.net>
References: <1432898714.2104.15.camel@sipsolutions.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Fri, 29 May 2015 13:25:14 +0200

> It's been a while since I sent anything for -next, but with the merge
> window getting closer I wanted to send a few more things, mostly fixes.
> Of course I expect that tomorrow somebody will send an important fix,
> but hey :-)

Isn't that always the case? :-)

Pulled, but there was a small conflict in include/net/mac80211.h which seemed
trivially resolvable.  Take a look and send me a fixup if I got it wrong,
thanks.

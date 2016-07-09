Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:57974 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933122AbcGIDyW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2016 23:54:22 -0400
Date: Fri, 08 Jul 2016 23:54:20 -0400 (EDT)
Message-Id: <20160708.235420.628090511086269636.davem@davemloft.net> (sfid-20160709_055426_599410_33AD092C)
To: johannes@sipsolutions.net
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211 2016-07-06
From: David Miller <davem@davemloft.net>
In-Reply-To: <1467808064-5312-1-git-send-email-johannes@sipsolutions.net>
References: <1467808064-5312-1-git-send-email-johannes@sipsolutions.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Wed,  6 Jul 2016 14:27:43 +0200

> People found two more bugs, so I have two more fixes. Both are related to
> memory - one's a leak, the other is a missing allocation failure check.
> 
> These are both tagged for stable already, and shouldn't conflict with any
> other patches, so if they won't go in any more it won't be a big deal.
> 
> Let me know if there's any problem.

Pulled, thanks.

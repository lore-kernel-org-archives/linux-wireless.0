Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:35163 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbcFKGQG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Jun 2016 02:16:06 -0400
Date: Fri, 10 Jun 2016 23:16:04 -0700 (PDT)
Message-Id: <20160610.231604.604019579709781335.davem@davemloft.net> (sfid-20160611_081613_425699_A9B2C9E4)
To: johannes@sipsolutions.net
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211-next 2016-06-09
From: David Miller <davem@davemloft.net>
In-Reply-To: <1465477466-23756-1-git-send-email-johannes@sipsolutions.net>
References: <1465477466-23756-1-git-send-email-johannes@sipsolutions.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=euc-kr
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Thu,  9 Jun 2016 15:04:25 +0200

> Here's my first set of changes for -next. The only exciting part are the
> changes from Micha©© to integrate FQ/codel into mac80211's software queues
> to improve cross-station latency and finally solve much of the latency
> issues so many people have spent so much time talking about, but never
> actually working on fixing until he did :)
> 
> Can I ask you to pull net into net-next, preferably before merging this?
> I have a patch that is unsafe without a fix that I submitted through
> mac80211 previously (last time, not the pull request a few minutes ago),
> and I'd prefer not to have that in our -next trees without the fix. If
> you merge net into net-next before this pull request I can fast-forward
> mac80211-next to this merge later.
> 
> Let me know if there's any problem.

Looks good, pulled, thanks!

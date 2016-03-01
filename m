Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:42508 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062AbcCAWLM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2016 17:11:12 -0500
Date: Tue, 01 Mar 2016 17:11:10 -0500 (EST)
Message-Id: <20160301.171110.1945667051881874679.davem@davemloft.net> (sfid-20160301_231119_404463_F2139A03)
To: johannes@sipsolutions.net
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211-next 2016-02-26
From: David Miller <davem@davemloft.net>
In-Reply-To: <1456519067-8175-1-git-send-email-johannes@sipsolutions.net>
References: <1456519067-8175-1-git-send-email-johannes@sipsolutions.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Fri, 26 Feb 2016 21:37:46 +0100

> Let's try this again. I backed out some of the rfkill changes
> that are buggy and fixed some of that too. I also left out the
> one that generated the big discussion, but I still think it's
> the saner thing to do rather than requiring userspace to poke
> around that much with sysfs when all it wants to do is tell
> us what it thinks should be "airplane mode". Anyway, wanted to
> get these things in before sorting that out.
> 
> Still the ARM patch in here - acked by the relevant people to
> fit into the series (rfkill -> ARM -> rfkill with dependencies
> that way); and, as Emmanuel reminded me, an iwlwifi patch that
> has similar dependency issues and we decided to take through
> my tree.
> 
> Let me know if there's any problem.

There was a minor merge conflict with net/mac80211/debugfs.c, take
a look and send me any fixups necessary.

Thanks!

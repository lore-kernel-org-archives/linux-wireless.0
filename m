Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:38590 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751099AbcJCFyE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Oct 2016 01:54:04 -0400
Date: Mon, 03 Oct 2016 01:54:01 -0400 (EDT)
Message-Id: <20161003.015401.1915647209236695770.davem@davemloft.net> (sfid-20161003_075416_163098_51AF6803)
To: johannes@sipsolutions.net
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211-next 2016-09-30
From: David Miller <davem@davemloft.net>
In-Reply-To: <1475252077-6165-1-git-send-email-johannes@sipsolutions.net>
References: <1475252077-6165-1-git-send-email-johannes@sipsolutions.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Fri, 30 Sep 2016 18:14:36 +0200

> Last pull request before the merge window, since it's about to open :)
> It seems that everyone finally agreed on the NAN (neighbor awareness
> networking) APIs, so we have that, along with some other things.
> 
> Let me know if there's any problem.

Johannes, I merged net into net-next before trying to perform this pull
and there are a few conflicts which I am not comfortable resolving on
my own.

Could you please look into this and send me a new pull request with the
conflicts resolved?

Thanks!

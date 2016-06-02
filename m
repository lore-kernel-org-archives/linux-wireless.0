Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:49963 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206AbcFBAxo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2016 20:53:44 -0400
Date: Wed, 01 Jun 2016 17:53:43 -0700 (PDT)
Message-Id: <20160601.175343.1760786915246195795.davem@davemloft.net> (sfid-20160602_025349_515508_DB0A5EBC)
To: johannes@sipsolutions.net
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211 2016-06-01
From: David Miller <davem@davemloft.net>
In-Reply-To: <1464775875-10494-1-git-send-email-johannes@sipsolutions.net>
References: <1464775875-10494-1-git-send-email-johannes@sipsolutions.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Wed,  1 Jun 2016 12:11:14 +0200

> For now, I have just three fixes for the current cycle.
> 
> One of them, the hwsim one, becomes interesting with some pending
> work to make hwsim work for unprivileged users in namespaces, and
> I don't want to allow them to crash the system ... I'll thus wait
> with that patch until you pull this into net-next also, so I can
> pull it back for mac80211-next.
> 
> Let me know if there's any problem.

Pulled, thanks!

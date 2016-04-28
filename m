Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:42211 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274AbcD1Uzy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Apr 2016 16:55:54 -0400
Date: Thu, 28 Apr 2016 16:55:52 -0400 (EDT)
Message-Id: <20160428.165552.1313548299399709913.davem@davemloft.net> (sfid-20160428_225557_471549_AA872F35)
To: johannes@sipsolutions.net
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211 2016-04-27
From: David Miller <davem@davemloft.net>
In-Reply-To: <1461747447-11287-1-git-send-email-johannes@sipsolutions.net>
References: <1461747447-11287-1-git-send-email-johannes@sipsolutions.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Wed, 27 Apr 2016 10:57:26 +0200

> While writing some new code yesterday, I found and fixed a per-CPU memory
> leak, this pull request has just a single patch addressing that.
> 
> Let me know if there's any problem.

Pulled, thanks a lot.

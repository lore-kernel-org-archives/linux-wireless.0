Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:32877 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756337Ab2AERbs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jan 2012 12:31:48 -0500
Date: Thu, 05 Jan 2012 12:30:39 -0500 (EST)
Message-Id: <20120105.123039.977245333906219511.davem@davemloft.net> (sfid-20120105_183153_130575_6C724157)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: pull request: wireless-next 2012-01-05
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120105160938.GC10666@tuxdriver.com>
References: <20120105160938.GC10666@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Thu, 5 Jan 2012 11:09:38 -0500

> Here is the last wireless "feature" pull request intended for 3.3.
> Mostly minutia, but highlights include an NFC spec update and some
> relicensing of regulatory code under the ISC license.
> 
> After consulation with Kalle, I have reverted the ath6kl USB bits that
> were causing build problems.
> 
> Please let me know if there are problems!
> 
> John
> 
> P.S. Sorry about the "ssh://" URL -- git.kernel.org seems a bit slow
> about syncing today...

That ssh URL would only work for you, since I don't have permission to get
at your trees even just to pull.

I pulled from the equivalent git:// URL, the top commit was the ath6kl
USB revert.

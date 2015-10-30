Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:33731 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030759AbbJ3LjI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Oct 2015 07:39:08 -0400
Date: Fri, 30 Oct 2015 20:39:06 +0900 (KST)
Message-Id: <20151030.203906.57461318217584400.davem@davemloft.net> (sfid-20151030_123915_098074_F94E962E)
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: pull-request: wireless-drivers-next 2015-10-29
From: David Miller <davem@davemloft.net>
In-Reply-To: <87d1vxo3ap.fsf@kamboji.qca.qualcomm.com>
References: <87d1vxo3ap.fsf@kamboji.qca.qualcomm.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kvalo@codeaurora.org>
Date: Thu, 29 Oct 2015 21:58:06 +0200

> here's hopefully my last pull request for 4.4. ssb had a new Kconfig
> entry and that's why this touches arch/mips/bcm47xx/Kconfig. ssb also
> did some code shuffling and moved code from b43 to ssb subsystem.
> Otherwise should be business as usual.
> 
> While writing this I noticed that Fengwei Yin had a problem with the
> From field and that's why you see "yfw" in the stats below. I considered
> that this isn't a big enough problem to justify rebasing my tree, but
> let me know if you think otherwise.
> 
> Please let me know if there are any problems.

Pulled, thanks.

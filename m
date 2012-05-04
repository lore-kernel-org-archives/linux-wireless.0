Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:54808 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379Ab2EDQIq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 May 2012 12:08:46 -0400
Date: Fri, 04 May 2012 12:07:36 -0400 (EDT)
Message-Id: <20120504.120736.1896153625895120398.davem@davemloft.net> (sfid-20120504_180901_732554_C4869BFA)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kerenl.org,
	linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2012-05-03
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120503173749.GQ9285@tuxdriver.com>
References: <20120503173749.GQ9285@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Thu, 3 May 2012 13:37:50 -0400

> Here is another trio of fixes intended for 3.4.  The fix from Eric
> Dumazet corrects skb truesize reporting in iwlwifi, avoiding a
> potential exhaustion of kernel memory due to differet socket memory
> accounting for these skb allocations.  The fix from Franky Lin avoids
> a double unlock on a spinlock in brcmfmac.  Finally, Rajkumar Manoharan
> reverts an earlier patch that created a minor regression in ath9k.

Pulled, thanks John.

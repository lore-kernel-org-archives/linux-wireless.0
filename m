Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34291
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751174Ab0GWVDF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jul 2010 17:03:05 -0400
Date: Fri, 23 Jul 2010 14:03:20 -0700 (PDT)
Message-Id: <20100723.140320.116366019.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: pull request: wireless-next-2.6 2010-07-23
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100723204029.GD2426@tuxdriver.com>
References: <20100723204029.GD2426@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Fri, 23 Jul 2010 16:40:29 -0400

> Yet another batch intended for 2.6.36...  Mostly the usual random lot
> of stuff, mostly driver updates.  This batch also includes a flurry
> of Sparse-inspired patches from me -- it is hard to resist once the
> "bug" bites!  As usual, all of these have been cooking in linux-next
> for at least several days.
> 
> Please let me know if there are problems!

Auto-merging drivers/net/wireless/iwlwifi/iwl-commands.h
CONFLICT (content): Merge conflict in drivers/net/wireless/iwlwifi/iwl-commands.h

I don't even have to look at the file to know that it's
another one of those __packed things.

I'll fix it up again, but I know you can sense how tiring
this has become for me.

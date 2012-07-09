Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:53399 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058Ab2GIG6J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 02:58:09 -0400
Date: Sun, 08 Jul 2012 23:58:08 -0700 (PDT)
Message-Id: <20120708.235808.1602900783296556684.davem@davemloft.net> (sfid-20120709_085814_909622_65FA3BFA)
To: johannes@sipsolutions.net
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] etherdevice: introduce broadcast_ether_addr
From: David Miller <davem@davemloft.net>
In-Reply-To: <1341310587.5131.2.camel@jlt3.sipsolutions.net>
References: <1341310587.5131.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Tue, 03 Jul 2012 12:16:27 +0200

> From: Johannes Berg <johannes.berg@intel.com>
> 
> A lot of code has either the memset or an
> inefficient copy from a static array that
> contains the all-ones broadcast address.
> Introduce broadcast_ether_addr() to fill
> an address with all ones, making the code
> clearer and allowing us to get rid of the
> various constant arrays.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

I would prefer if this were named "eth_something()", thanks.

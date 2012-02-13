Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:59173 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326Ab2BMFue (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Feb 2012 00:50:34 -0500
Date: Mon, 13 Feb 2012 00:50:25 -0500 (EST)
Message-Id: <20120213.005025.199077040083086801.davem@davemloft.net> (sfid-20120213_065048_318134_0B602165)
To: joe@perches.com
Cc: David.Laight@ACULAB.COM, jeffrey.t.kirsher@intel.com,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH net-next] drivers/net: Remove boolean comparisons to
 true/false
From: David Miller <davem@davemloft.net>
In-Reply-To: <1328822243.29329.11.camel@joe2Laptop>
References: <AE90C24D6B3A694183C094C60CF0A2F6026B6E62@saturn3.aculab.com>
	<20120209.133413.349832435589531136.davem@davemloft.net>
	<1328822243.29329.11.camel@joe2Laptop>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Joe Perches <joe@perches.com>
Date: Thu, 09 Feb 2012 13:17:23 -0800

> Booleans should not be compared to true or false
> but be directly tested or tested with !.
> 
> Done via cocci script:
 ...
> Signed-off-by: Joe Perches <joe@perches.com>

Applied.

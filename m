Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:45204 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950Ab2EJB4p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 May 2012 21:56:45 -0400
Date: Wed, 09 May 2012 21:53:30 -0400 (EDT)
Message-Id: <20120509.215330.1797609915710094377.davem@davemloft.net> (sfid-20120510_035757_812025_8C6B1408)
To: joe@perches.com
Cc: julia.lawall@lip6.fr, netdev@vger.kernel.org,
	bridge@lists.linux-foundation.org, netfilter-devel@vger.kernel.org,
	netfilter@vger.kernel.org, coreteam@netfilter.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-bluetooth@vger.kernel.org
Subject: Re: [PATCH 00/13] net: Add and use ether_addr_equal
From: David Miller <davem@davemloft.net>
In-Reply-To: <1336614484.1905.19.camel@joe2Laptop>
References: <cover.1336538937.git.joe@perches.com>
	<20120509.212110.437114897180819434.davem@davemloft.net>
	<1336614484.1905.19.camel@joe2Laptop>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Joe Perches <joe@perches.com>
Date: Wed, 09 May 2012 18:48:04 -0700

> Maybe just a single patch?

Yes, I think high density on this one, it's extremely
mechanical.

> Also the compare_ether_addr_64bits function is
> still used a couple dozen times.  Maybe another
> patch for those?  ether_addr_equal_64bits?

Use your best judgment.


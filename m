Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:37316 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab3HAAuj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Jul 2013 20:50:39 -0400
Date: Wed, 31 Jul 2013 17:50:36 -0700 (PDT)
Message-Id: <20130731.175036.1962194560242893587.davem@davemloft.net> (sfid-20130801_025101_547274_9D4A3732)
To: joe@perches.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-afs@lists.infradead.org, linux-hams@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/8] include/net: next set of extern removals
From: David Miller <davem@davemloft.net>
In-Reply-To: <cover.1375316912.git.joe@perches.com>
References: <cover.1375316912.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Joe Perches <joe@perches.com>
Date: Wed, 31 Jul 2013 17:31:31 -0700

> Standardize on no extern use on function prototypes
> 
> Joe Perches (8):
>   addrconf.h: Remove extern function prototypes
>   af_unix.h: Remove extern from function prototypes
>   af_rxrpc.h: Remove extern from function prototypes
>   arp/neighbour.h: Remove extern from function prototypes
>   ax25.h: Remove extern from function prototypes
>   cfg80211.h/mac80211.h: Remove extern from function prototypes
>   checksum: Remove extern from function prototypes
>   cls_cgroup.h netprio_cgroup.h: Remove extern from function prototypes

I guess there is no time like the present to apply something like
this, so I have.

Please hold off for a few days before the next batch so we can watch
for any fallout from this one.

Thanks Joe.

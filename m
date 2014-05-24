Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:37721 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207AbaEXSGr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 May 2014 14:06:47 -0400
Date: Sat, 24 May 2014 14:06:45 -0400 (EDT)
Message-Id: <20140524.140645.430202997634061971.davem@davemloft.net> (sfid-20140524_200710_498014_23B76F85)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2014-05-23
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140523150733.GC13311@tuxdriver.com>
References: <20140523150733.GC13311@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Fri, 23 May 2014 11:07:34 -0400

> I have two more fixes intended for the 3.15 stream...
> 
> For the iwlwifi one, Emmanuel says:
> 
> "A race has been discovered in the beacon filtering code. Since the
> fix is too big for 3.15, I disable here the feature."
> 
> For the bluetooth one, Gustavo says:
> 
> "This pull request contains a very important fix for 3.15. Here we fix the
> permissions of a debugfs file that would otherwise allow unauthorized users
> to write content to it."
> 
> Please let me know if there are problems!

Pulled, thanks a lot John.


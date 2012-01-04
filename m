Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:52302 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585Ab2ADTu2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jan 2012 14:50:28 -0500
Date: Wed, 04 Jan 2012 14:49:23 -0500 (EST)
Message-Id: <20120104.144923.372584452455227614.davem@davemloft.net> (sfid-20120104_205046_513040_4389F3FC)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2012-01-04 #2
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120104164339.GG2540@tuxdriver.com>
References: <20120104164339.GG2540@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 4 Jan 2012 11:43:40 -0500

> Here are a handful of straggler wireless fixes for 3.2.  Included is
> a NULL pointer fix for mwifiex, a regression fix for handling rx
> header lengths for differnt b43 firmwares in PIO mode, a revert of
> a one-liner for Bluetooth HCI that was causing uncomfortable delays
> during resume, and an ath9k fix for a panic when running in AP mode
> with aggregation disabled.
> 
> The Bluetooth fix is a one-liner change of a delay value.  The mwifiex,
> b43, and ath9k fixes are relatively small and isolated to their
> respective drivers.
> 
> Please let me know if there are problems!
...
>   git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless.git for-davem

Pulled, thanks.

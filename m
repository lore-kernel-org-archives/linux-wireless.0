Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:48104 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755694Ab1GAIxh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jul 2011 04:53:37 -0400
Date: Fri, 01 Jul 2011 01:52:27 -0700 (PDT)
Message-Id: <20110701.015227.1310214485297198560.davem@davemloft.net> (sfid-20110701_105359_478634_E39EADFD)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2011-06-30
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110630173223.GA12963@tuxdriver.com>
References: <20110630173223.GA12963@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Thu, 30 Jun 2011 13:32:25 -0400

> Here is a batch of fixes intended for 3.0.  Arik gives us a fix for a
> potential NULL dereference in mac80211.  Emmanuel gives us a fix for a
> regression introduced by "iwlagn: support multiple TBs per command" that
> can corrupt memory.  Eugene (and Bob) gives a memory leak fix for ath5k.
> Evgeni gives us a preprocessor-related fix that makes modinfo output
> make more sense for iwlagn.  Johannes gives us a trio of fixes, all
> isolated to the bowels of iwlagn.  I overlayed a fixup on top of one of
> Johannes's patches, since there was some confusion between DMA and PCI
> API usage.  Finally, Rajkumar gives us an ath9k fix to ensure the chip
> is properly awakened even if there is no active interface when the
> resume occurs.
> 
> Please let me know if there are problems!

Pulled, thanks John.

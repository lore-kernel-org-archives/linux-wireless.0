Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:56588 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132AbXEGIPv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2007 04:15:51 -0400
Date: Mon, 7 May 2007 09:15:31 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Michael Wu <flamingice@sourmilk.net>
Cc: David Miller <davem@davemloft.net>,
	John Linville <linville@tuxdriver.com>,
	Jeff Garzik <jeff@garzik.org>, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	Andrea Merello <andrea.merello@gmail.com>
Subject: Re: [PATCH 2/2] Add rtl8187 wireless driver
Message-ID: <20070507081531.GA28498@infradead.org>
References: <20070507073636.4232.93444.stgit@panda.sourmilk.net> <200705070346.17868.flamingice@sourmilk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200705070346.17868.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 07, 2007 at 03:46:17AM -0400, Michael Wu wrote:
> This patch adds a mac80211 based wireless driver for the rtl8187 USB
> wireless card.
> 
> Signed-off-by: Michael Wu <flamingice@sourmilk.net>
> ---
> 
>  MAINTAINERS                                        |   10 
>  drivers/net/wireless/Kconfig                       |    2 
>  drivers/net/wireless/Makefile                      |    3 
>  drivers/net/wireless/mac80211/Kconfig              |    1 
>  drivers/net/wireless/mac80211/Makefile             |    1 
>  drivers/net/wireless/mac80211/rtl818x/Kconfig      |   16 
>  drivers/net/wireless/mac80211/rtl818x/Makefile     |    2 
>  drivers/net/wireless/mac80211/rtl818x/rtl8187.h    |  125 +++
>

Driver shouldn't be in another useless sub-hiearchay just because
of some common code they use.


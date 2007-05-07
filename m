Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:46291 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934400AbXEGPZ3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2007 11:25:29 -0400
Message-ID: <463F44E6.5030705@garzik.org>
Date: Mon, 07 May 2007 11:25:26 -0400
From: Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
To: Michael Wu <flamingice@sourmilk.net>
CC: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Andrea Merello <andrea.merello@gmail.com>
Subject: Re: [PATCH v2] Add rtl8187 wireless driver
References: <200705071022.11711.flamingice@sourmilk.net>
In-Reply-To: <200705071022.11711.flamingice@sourmilk.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Wu wrote:
> This patch adds a mac80211 based wireless driver for the rtl8187 USB
> wireless card.
> 
> Signed-off-by: Michael Wu <flamingice@sourmilk.net>
> ---
> 
>  MAINTAINERS                                    |   10 
>  drivers/net/wireless/Kconfig                   |    2 
>  drivers/net/wireless/Makefile                  |    3 
>  drivers/net/wireless/rtl818x/Kconfig           |   16 +
>  drivers/net/wireless/rtl818x/Makefile          |    2 
>  drivers/net/wireless/rtl818x/rtl8187.h         |  125 ++++
>  drivers/net/wireless/rtl818x/rtl8187_dev.c     |  730 ++++++++++++++++++++++++
>  drivers/net/wireless/rtl818x/rtl8187_rtl8225.c |  744 ++++++++++++++++++++++++
>  drivers/net/wireless/rtl818x/rtl8187_rtl8225.h |   30 +
>  drivers/net/wireless/rtl818x/rtl818x.h         |  212 +++++++
>  10 files changed, 1874 insertions(+), 0 deletions(-)

Much better.

For the record, new wireless drivers go TO John Linville for merging 
(and he pushes to me, in turn).

I am a bit skeptical that multiple files are needed.  It seems like 
drivers/net/wireless/rtl818x.c would be a better path, a la tg3.c.

	Jeff




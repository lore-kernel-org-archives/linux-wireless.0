Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:33001 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752120AbXGRWbS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jul 2007 18:31:18 -0400
Message-ID: <469E94B2.7000709@garzik.org>
Date: Wed, 18 Jul 2007 18:31:14 -0400
From: Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Please pull 'upstream-jgarzik' branch of wireless-2.6
References: <20070718021953.GC26907@tuxdriver.com>
In-Reply-To: <20070718021953.GC26907@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> A few more for 2.6.23...
> 
> Thanks!
> 
> John
> 
> ---
> 
> The following changes since commit 4ad1366376bfef32ec0ffa12d1faa483d6f330bd:
>   NeilBrown (1):
>         md: change bitmap_unplug and others to void functions
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git upstream-jgarzik
> 
> Daniel Drake (1):
>       zd1211rw: Add ID for Siemens Gigaset USB Stick 54
> 
> Jean Tourrilhes (1):
>       softmac: Channel is listed twice in scan output
> 
> Masakazu Mokuno (1):
>       zd1211rw: Add ID for Planex GW-US54GXS
> 
> Zhu Yi (4):
>       ipw2100: Fix `iwpriv set_power` error
>       Fix ipw2200 set wrong power parameter causing firmware error
>       ipw2200: Fix ipw_isr() comments error on shared IRQ
>       Update version ipw2200 stamp to 1.2.2
> 
>  drivers/net/wireless/ipw2100.c         |    6 +++---
>  drivers/net/wireless/ipw2200.c         |   18 ++++++++----------
>  drivers/net/wireless/zd1211rw/zd_usb.c |    2 ++
>  net/ieee80211/ieee80211_wx.c           |    7 ++-----
>  4 files changed, 15 insertions(+), 18 deletions(-)

pulled



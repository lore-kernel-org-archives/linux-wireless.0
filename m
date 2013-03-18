Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:59303 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750930Ab3CRC7q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Mar 2013 22:59:46 -0400
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
To: Stanislaw Gruszka <stf_xl@wp.pl>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	linux-wireless@vger.kernel.org,
	Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: Re: [PATCH 0/25] rt2800: add experimental support for 5592 chip
Date: Mon, 18 Mar 2013 11:00:43 +0800
Message-Id: <1363575643-8981-1-git-send-email-gaowanlong@cn.fujitsu.com> (sfid-20130318_035950_700923_C96FBD35)
In-Reply-To: <1363457993-15541-1-git-send-email-stf_xl@wp.pl>
References: <1363457993-15541-1-git-send-email-stf_xl@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


>This patch set add support for 5592 a new Ralink wlan chip. Register
>programming code is all is based on Ralink linux driver available at
>(despite the url it linux driver download web page ):
>
>http://www.mediatek.com/_en/07_downloads/01_windows.php?sn=501
>
>Currently only support for USB devices is added, PCIe is on the way
>together with some other changes that will clean BBP/RF rt2800
>programming code, which is now quite Lionel (messy :-).


Thank you very much, this works well on my new RT5572 wireless device.

Tested-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>

>
> Kconfig     |    7 
> rt2800.h    |  103 ++++++-
> rt2800lib.c |  857 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++----
> rt2800pci.c |    5 
> rt2800usb.c |   63 ++++
> rt2x00.h    |   10 
> 6 files changed, 989 insertions(+), 56 deletions(-)


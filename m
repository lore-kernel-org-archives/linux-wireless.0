Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:49986 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718AbbJVMYI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2015 08:24:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: glen lee <glen.lee@atmel.com>
Cc: linux-wireless@vger.kernel.org, Rachel Kim <rachel.kim@atmel.com>,
	devel@driverdev.osuosl.org, Chris Park <chris.park@atmel.com>,
	gregkh@linuxfoundation.org,
	Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>,
	Johnny Kim <johnny.kim@atmel.com>,
	linux-kernel@vger.kernel.org, Tony Cho <tony.cho@atmel.com>,
	Leo Kim <leo.kim@atmel.com>
Subject: Re: [PATCH 00/19] staging/wilc1000 cleanups
Date: Thu, 22 Oct 2015 14:23:53 +0200
Message-ID: <4948909.qZ1ebjqtXf@wuerfel> (sfid-20151022_142448_414037_CD638500)
In-Reply-To: <562763BC.5030107@atmel.com>
References: <1445381258-1455986-1-git-send-email-arnd@arndb.de> <562763BC.5030107@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 21 October 2015 19:06:52 glen lee wrote:
> Hi arnd,
> 
> Thanks for the all the patches. 
> About the patch ( use proper naming for global symbols ),
> We are planning to use this driver not only for wilc1000 but also for
> other atmel wireless driver. I'd appreciate if you could use wl instead of wilc1000.
> 
> And the global variable g_linux_wlan will be placed in netdevice private data
> and finally it will be removed. I already posted some of those patches.

I couldn't find the patches anywhere, but I've updated my series now
to rename the symbols to wilc_* and to remove most but not all references to
g_linux_wlan (or wilc_dev after my rename). Do you want me to post those
so you can integrate them, or should I have a look at what you sent first
(please send me a copy then).

	Arnd

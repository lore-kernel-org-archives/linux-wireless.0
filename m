Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:34485 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752605Ab1CaWxp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Mar 2011 18:53:45 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
CC: "mcgrof@gmail.com" <mcgrof@gmail.com>,
	"lrodriguez@atheros.com" <lrodriguez@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Frank Huang <frankh@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Marc Yang <yangyang@marvell.com>
Date: Thu, 31 Mar 2011 15:53:32 -0700
Subject: RE: [PATCH 1/5] compat-wireless: add support for mwifiex
Message-ID: <477F20668A386D41ADCC57781B1F704307FA844AD8@SC-VEXCH1.marvell.com>
References: <1301588527-16615-1-git-send-email-hauke@hauke-m.de>
 <477F20668A386D41ADCC57781B1F704307FA844A89@SC-VEXCH1.marvell.com>
 <4D94F9C8.9060804@hauke-m.de>
In-Reply-To: <4D94F9C8.9060804@hauke-m.de>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Hauke,

> > I'm getting an error in "compat-wireless-2.6.39-rc1-3-s/net/wireless/util.c:799" while compiling
> compat-wireless-2.6.39-rc1-3-s.tar.bz2.
> 
> mwifiex is not integrated in the last compat-wireless release from today
> it will be in compat-wireless-2011-04-01.
> The kernel version number in the compat-wireless release is the version
> the code is from. So compat-wireless-2.6.39-rc1-3-s is based on the
> source code from kernel version 2.6.39-rc1, it should compile and work
> with every kernel from 2.6.24 to 2.6.39.
> 
> You could build your own version based on the latest version of
> linux-next. It is described at:
> http://wireless.kernel.org/en/users/Download/hacking

Thanks a lot for the information.

> I created a self made version with the lasted fixes for compat-wireless
> and and mwifiex at:
> http://hauke-m.de/fileadmin/openwrt/compat-wireless-2011-03-31-1.tar.bz2

I tested this tar ball. It passed compilation and mwifiex works fine.

Thanks,

Bing


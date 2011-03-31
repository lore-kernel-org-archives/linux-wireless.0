Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:40713 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759227Ab1CaT3D convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Mar 2011 15:29:03 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Hauke Mehrtens <hauke@hauke-m.de>,
	"mcgrof@gmail.com" <mcgrof@gmail.com>,
	"lrodriguez@atheros.com" <lrodriguez@atheros.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Frank Huang <frankh@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>
Date: Thu, 31 Mar 2011 12:28:55 -0700
Subject: RE: [PATCH 1/5] compat-wireless: add support for mwifiex
Message-ID: <477F20668A386D41ADCC57781B1F704307FA844A04@SC-VEXCH1.marvell.com>
References: <1301588527-16615-1-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1301588527-16615-1-git-send-email-hauke@hauke-m.de>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Hauke,

> -----Original Message-----
> From: Hauke Mehrtens [mailto:hauke@hauke-m.de]
> Sent: Thursday, March 31, 2011 9:22 AM
> To: mcgrof@gmail.com; lrodriguez@atheros.com
> Cc: linux-wireless@vger.kernel.org; Hauke Mehrtens; Bing Zhao
> Subject: [PATCH 1/5] compat-wireless: add support for mwifiex
> 
> This adds support for mwifiex into compat-wireless.
> 
> This is only compile tested as I do not have such a device.

I will test it.

Thanks,

Bing

> 
> CC: Bing Zhao <bzhao@marvell.com>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  config.mk                                 |    4 +
>  patches/01-netdev.patch                   |   11 ++++
>  patches/25-multicast-list_head.patch      |   42 ++++++++++++--
>  patches/26-sdio-quirks.patch              |   12 ++++
>  patches/29-libertas_sdio_no_suspend.patch |   34 -----------
>  patches/29-sdio_no_suspend.patch          |   86 +++++++++++++++++++++++++++++
>  scripts/admin-update.sh                   |    1 +
>  7 files changed, 151 insertions(+), 39 deletions(-)
>  delete mode 100644 patches/29-libertas_sdio_no_suspend.patch
>  create mode 100644 patches/29-sdio_no_suspend.patch


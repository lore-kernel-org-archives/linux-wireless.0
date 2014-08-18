Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:50190 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbaHRHqp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Aug 2014 03:46:45 -0400
Cc: Dedy Lansky <qca_dlansky@qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH v2 00/13] wil6210 misc updates
Date: Mon, 18 Aug 2014 10:46:39 +0300
Message-ID: <3159817.tZ1i7iY0M1@lx-wigig-72> (sfid-20140818_094648_706430_D3C93622)
In-Reply-To: <1407310322-22568-1-git-send-email-qca_dlansky@qca.qualcomm.com>
References: <1407310322-22568-1-git-send-email-qca_dlansky@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday, August 06, 2014 10:31:48 AM Dedy Lansky wrote:
> Some updates and bug fixes for wil6210 driver.
> 
> Dedy Lansky (1):
>   wil6210: Limit max number of associated stations
> 
> Vladimir Kondratiev (12):
>   wil6210: map MAC timer for packet lifetime into debugfs
>   wil6210: fix race in reset
>   wil6210: update copyright year 2014
>   wil6210: check error in wil_target_reset()
>   wil6210: wait longer for hardware reset completion
>   wil6210: Workaround for Sparrow with bad device id
>   wil6210: convert debugfs to the table mode
>   wil6210: fix beamforming data reporting
>   wil6210: fix false "scan timeout"
>   wil6210: fix free'd memory access in wil_if_free()
>   wil6210: cfg80211_rx_mgmt to use GFP_ATOMIC
>   wil6210: fix access after free in wil_pcie_remove()
> 
>  drivers/net/wireless/ath/wil6210/cfg80211.c   |   6 +-
>  drivers/net/wireless/ath/wil6210/debugfs.c    | 331 ++++++++++++++++++++------
>  drivers/net/wireless/ath/wil6210/interrupt.c  |   2 +-
>  drivers/net/wireless/ath/wil6210/main.c       |  30 ++-
>  drivers/net/wireless/ath/wil6210/netdev.c     |   8 +-
>  drivers/net/wireless/ath/wil6210/pcie_bus.c   |   7 +-
>  drivers/net/wireless/ath/wil6210/rx_reorder.c |  16 ++
>  drivers/net/wireless/ath/wil6210/txrx.c       |   3 +-
>  drivers/net/wireless/ath/wil6210/txrx.h       |   2 +-
>  drivers/net/wireless/ath/wil6210/wil6210.h    |  17 +-
>  drivers/net/wireless/ath/wil6210/wmi.c        |  47 ++--
>  drivers/net/wireless/ath/wil6210/wmi.h        |   4 +-
>  12 files changed, 327 insertions(+), 146 deletions(-)
> 
> 
Hi John,

Could you please merge these patches? Somehow, it was forgotten.

Thanks, Vladimir


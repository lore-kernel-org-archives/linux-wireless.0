Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:48614 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622AbbC2Qr1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Mar 2015 12:47:27 -0400
Message-ID: <55182C9C.60900@broadcom.com> (sfid-20150329_184733_131394_6DF63750)
Date: Sun, 29 Mar 2015 18:47:24 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: <linux-kernel@vger.kernel.org>,
	Brett Rudley <brudley@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	"Pieter-Paul Giesberts" <pieterpg@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Daniel Kim <dekim@broadcom.com>,
	<linux-wireless@vger.kernel.org>,
	<brcm80211-dev-list@broadcom.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH 84/86] brcm80211: drop pci_ids include
References: <1427635734-24786-1-git-send-email-mst@redhat.com> <1427635734-24786-85-git-send-email-mst@redhat.com>
In-Reply-To: <1427635734-24786-85-git-send-email-mst@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/29/15 15:43, Michael S. Tsirkin wrote:
> This file does not use any pci ids, drop
> pci_ids.h include.

Acked-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: Michael S. Tsirkin<mst@redhat.com>
> ---
>   drivers/net/wireless/brcm80211/brcmfmac/sdio.c | 1 -
>   1 file changed, 1 deletion(-)
>
> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
> index 5c4755d..da479d4 100644
> --- a/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
> +++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
> @@ -18,7 +18,6 @@
>   #include<linux/kernel.h>
>   #include<linux/kthread.h>
>   #include<linux/printk.h>
> -#include<uapi/linux/pci_ids.h>
>   #include<linux/netdevice.h>
>   #include<linux/interrupt.h>
>   #include<linux/sched.h>


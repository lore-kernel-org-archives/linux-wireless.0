Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:18116 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231AbbC2Qqv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Mar 2015 12:46:51 -0400
Message-ID: <55182C77.1000706@broadcom.com> (sfid-20150329_184710_623751_C4CFD8FE)
Date: Sun, 29 Mar 2015 18:46:47 +0200
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
	Chen-Yu Tsai <wens@csie.org>,
	Hans de Goede <hdegoede@redhat.com>,
	<linux-wireless@vger.kernel.org>,
	<brcm80211-dev-list@broadcom.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH 83/86] brcm80211: drop pci dependency
References: <1427635734-24786-1-git-send-email-mst@redhat.com> <1427635734-24786-84-git-send-email-mst@redhat.com>
In-Reply-To: <1427635734-24786-84-git-send-email-mst@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/29/15 15:43, Michael S. Tsirkin wrote:
> This file does not use any pci APIs, drop
> pci header includes.

Acked-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: Michael S. Tsirkin<mst@redhat.com>
> ---
>   drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c | 2 --
>   1 file changed, 2 deletions(-)
>
> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
> index 227cb33..9331486 100644
> --- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
> +++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
> @@ -17,8 +17,6 @@
>
>   #include<linux/types.h>
>   #include<linux/netdevice.h>
> -#include<linux/pci.h>
> -#include<uapi/linux/pci_ids.h>
>   #include<linux/sched.h>
>   #include<linux/completion.h>
>   #include<linux/scatterlist.h>


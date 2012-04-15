Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:2584 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751797Ab2DOMXT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Apr 2012 08:23:19 -0400
Message-ID: <4F8ABDB5.6090102@gmail.com> (sfid-20120415_142355_176939_B3496E40)
Date: Sun, 15 Apr 2012 14:23:17 +0200
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
CC: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	IvDoorn@gmail.com, linville@tuxdriver.com,
	helmut.schaa@googlemail.com
Subject: Re: [PATCH] wireless: rt2x00: rt2800pci add more RT539x ids
References: <1334439201-13424-1-git-send-email-xose.vazquez@gmail.com>
In-Reply-To: <1334439201-13424-1-git-send-email-xose.vazquez@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/14/12 23:33, Xose Vazquez Perez wrote:
> RT539x devices:
> (0x1814, 0x5362)
> (0x1814, 0x5392)
> 
> Taken from ralink driver 2011_0406_RT5390_RT5392_Linux_STA_V2.5.0.3_DPO
> 
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2800pci.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
> index 0397bbf..7968f45 100644
> --- a/drivers/net/wireless/rt2x00/rt2800pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2800pci.c
> @@ -1184,7 +1184,9 @@ static DEFINE_PCI_DEVICE_TABLE(rt2800pci_device_table) = {
>  	{ PCI_DEVICE(0x1814, 0x3593) },
>  #endif
>  #ifdef CONFIG_RT2800PCI_RT53XX
> +	{ PCI_DEVICE(0x1814, 0x5362) },
>  	{ PCI_DEVICE(0x1814, 0x5390) },
> +	{ PCI_DEVICE(0x1814, 0x5392) },
>  	{ PCI_DEVICE(0x1814, 0x539a) },
>  	{ PCI_DEVICE(0x1814, 0x539f) },
>  #endif


-- 
---
Gertjan

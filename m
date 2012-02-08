Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:2813 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754289Ab2BHWDE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Feb 2012 17:03:04 -0500
Message-ID: <4F32F116.6040106@gmail.com> (sfid-20120208_230307_298874_E04400F6)
Date: Wed, 08 Feb 2012 23:03:02 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: John Li <john.li.mediatek@gmail.com>
CC: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	John Li <chen-yang.li@mediatek.com>
Subject: Re: [PATCH] rt2x00:Add debug message for new chipset
References: <1328707524-11415-1-git-send-email-john.li.mediatek@gmail.com>
In-Reply-To: <1328707524-11415-1-git-send-email-john.li.mediatek@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/08/12 14:25, John Li wrote:
> From: John Li <chen-yang.li@mediatek.com>
> 
> Signed-off-by: John Li <chen-yang.li@mediatek.com>

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2800lib.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index 22a1a8f..6bdf6d6 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -3949,7 +3949,7 @@ int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
>  	case RT5390:
>  		break;
>  	default:
> -		ERROR(rt2x00dev, "Invalid RT chipset detected.\n");
> +		ERROR(rt2x00dev, "Invalid RT chipset 0x%04x detected.\n", rt2x00dev->chip.rt);
>  		return -ENODEV;
>  	}
>  
> @@ -3968,7 +3968,7 @@ int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
>  	case RF5390:
>  		break;
>  	default:
> -		ERROR(rt2x00dev, "Invalid RF chipset 0x%x detected.\n",
> +		ERROR(rt2x00dev, "Invalid RF chipset 0x%04x detected.\n",
>  		      rt2x00dev->chip.rf);
>  		return -ENODEV;
>  	}


-- 
---
Gertjan

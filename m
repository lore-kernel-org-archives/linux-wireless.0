Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:2750 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751490Ab2BHWCm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Feb 2012 17:02:42 -0500
Message-ID: <4F32F100.6070302@gmail.com> (sfid-20120208_230246_181607_88BEC5A3)
Date: Wed, 08 Feb 2012 23:02:40 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: John Li <john.li.mediatek@gmail.com>
CC: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	John Li <chen-yang.li@mediatek.com>
Subject: Re: [PATCH] rt2x00:Fix typo
References: <1328707141-11355-1-git-send-email-john.li.mediatek@gmail.com>
In-Reply-To: <1328707141-11355-1-git-send-email-john.li.mediatek@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/08/12 14:19, John Li wrote:
> From: John Li <chen-yang.li@mediatek.com>
> 
> Signed-off-by: John Li <chen-yang.li@mediatek.com>

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
> index a0a7854..299c387 100644
> --- a/drivers/net/wireless/rt2x00/Kconfig
> +++ b/drivers/net/wireless/rt2x00/Kconfig
> @@ -163,7 +163,7 @@ config RT2800USB_RT53XX
>         depends on EXPERIMENTAL
>         ---help---
>           This adds support for rt53xx wireless chipset family to the
> -         rt2800pci driver.
> +         rt2800usb driver.
>           Supported chips: RT5370
>  
>  config RT2800USB_UNKNOWN


-- 
---
Gertjan

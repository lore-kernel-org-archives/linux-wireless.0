Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:35571 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab2BLPaJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Feb 2012 10:30:09 -0500
Received: by vcge1 with SMTP id e1so2673892vcg.19
        for <linux-wireless@vger.kernel.org>; Sun, 12 Feb 2012 07:30:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1328707141-11355-1-git-send-email-john.li.mediatek@gmail.com>
References: <1328707141-11355-1-git-send-email-john.li.mediatek@gmail.com>
Date: Sun, 12 Feb 2012 16:30:08 +0100
Message-ID: <CAOZOX0Un-8u58GnjCf6S+Tf5pjdpe4Fi1zX89BVFFbnoU2D4aw@mail.gmail.com> (sfid-20120212_163013_628035_0FFD4325)
Subject: Re: [PATCH] rt2x00:Fix typo
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: John Li <john.li.mediatek@gmail.com>
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	John Li <chen-yang.li@mediatek.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 8, 2012 at 2:19 PM, John Li <john.li.mediatek@gmail.com> wrote:
> From: John Li <chen-yang.li@mediatek.com>
>
> Signed-off-by: John Li <chen-yang.li@mediatek.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
> index a0a7854..299c387 100644
> --- a/drivers/net/wireless/rt2x00/Kconfig
> +++ b/drivers/net/wireless/rt2x00/Kconfig
> @@ -163,7 +163,7 @@ config RT2800USB_RT53XX
>        depends on EXPERIMENTAL
>        ---help---
>          This adds support for rt53xx wireless chipset family to the
> -         rt2800pci driver.
> +         rt2800usb driver.
>          Supported chips: RT5370
>
>  config RT2800USB_UNKNOWN
> --
> 1.7.6.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

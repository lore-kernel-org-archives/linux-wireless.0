Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38569 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306Ab2BHJ1p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Feb 2012 04:27:45 -0500
Received: by daed14 with SMTP id d14so329814dae.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Feb 2012 01:27:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1328681208-5734-1-git-send-email-john.li.mediatek@gmail.com>
References: <1328681208-5734-1-git-send-email-john.li.mediatek@gmail.com>
Date: Wed, 8 Feb 2012 10:27:45 +0100
Message-ID: <CAGXE3d_-pTTKxBJ9XWyF7J5XHQbNeVV=GjYC8ohoVOEvE6ryrA@mail.gmail.com> (sfid-20120208_102750_324645_8EF97F97)
Subject: Re: [PATCH] rt2x00:Fix typo
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: John Li <john.li.mediatek@gmail.com>
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	John Li <chen-yang.li@mediatek.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

On Wed, Feb 8, 2012 at 7:06 AM, John Li <john.li.mediatek@gmail.com> wrote:
> From: John Li <chen-yang.li@mediatek.com>

Your Signed-off-by line is missing here ...

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

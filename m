Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:45235 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283Ab0ILRgQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Sep 2010 13:36:16 -0400
Received: by qyk36 with SMTP id 36so1100345qyk.19
        for <linux-wireless@vger.kernel.org>; Sun, 12 Sep 2010 10:36:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100911164409.GA7432@broadcom.com>
References: <20100911164409.GA7432@broadcom.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Sun, 12 Sep 2010 19:35:55 +0200
Message-ID: <AANLkTinoeqnU7qk=RgSiQM3=9dge_9QGL0H33qR8hNXW@mail.gmail.com>
Subject: Re: [PATCH] Fix URLs for firmware files.
To: Henry Ptasinski <henryp@broadcom.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Sep 11, 2010 at 6:44 PM, Henry Ptasinski <henryp@broadcom.com> wrote:
> From 6c45ba230e63b6ee85b9a51962e545d6d0e5698c Mon Sep 17 00:00:00 2001
> From: Henry Ptasinski <henryp@broadcom.com>
> Date: Sat, 11 Sep 2010 09:40:20 -0700
> Subject: [PATCH] Fix URLs for firmware files.
>
>
> Signed-off-by: Henry Ptasinski <henryp@broadcom.com>
> ---
>  drivers/staging/brcm80211/README |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/staging/brcm80211/README b/drivers/staging/brcm80211/README
> index 97fa01c..c3ba9bb 100644
> --- a/drivers/staging/brcm80211/README
> +++ b/drivers/staging/brcm80211/README
> @@ -40,8 +40,8 @@ Firmware installation
>  Firmware is available from the Linux firmware repository at:
>
>        git://git.kernel.org/pub/scm/linux/kernel/git/dwmw2/linux-firmware.git
> -       http://git.kernel.org/pub/scm/linux/kernel/git/dwmw2/linux-firmware.git
> -       https://git.kernel.org/pub/scm/linux/kernel/git/dwmw2/linux-firmware.git
> +       http://git.kernel.org/?p=linux/kernel/git/dwmw2/linux-firmware.git
> +       https://git.kernel.org/?p=linux/kernel/git/dwmw2/linux-firmware.git
>
>  For all chips, copy brcm/bcm43xx-0-610-809-0.fw and
>  brcm/bcm43xx_hdr-0-610-809-0.fw to /lib/firmware/brcm (or wherever firmware is
> --
> 1.6.3.3
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Is there any chance of sharing firmware between brcm80211 and b43
eventually? (Also, are there plans to release redistributable firmware
for earlier PHYs, for use with b43 and/or a future version of
brcm80211 with legacy-PHY support?)

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)

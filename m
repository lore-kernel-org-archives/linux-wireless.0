Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:60686 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469Ab2BLPaa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Feb 2012 10:30:30 -0500
Received: by vbjk17 with SMTP id k17so2628343vbj.19
        for <linux-wireless@vger.kernel.org>; Sun, 12 Feb 2012 07:30:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1328707524-11415-1-git-send-email-john.li.mediatek@gmail.com>
References: <1328707524-11415-1-git-send-email-john.li.mediatek@gmail.com>
Date: Sun, 12 Feb 2012 16:30:29 +0100
Message-ID: <CAOZOX0WmKubGKBpkD7Ni8WhnCS5DkwQsvbZG0ncOw=jnQ7tqoQ@mail.gmail.com> (sfid-20120212_163033_678716_04D2A641)
Subject: Re: [PATCH] rt2x00:Add debug message for new chipset
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: John Li <john.li.mediatek@gmail.com>
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	John Li <chen-yang.li@mediatek.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 8, 2012 at 2:25 PM, John Li <john.li.mediatek@gmail.com> wrote:
> From: John Li <chen-yang.li@mediatek.com>
>
> Signed-off-by: John Li <chen-yang.li@mediatek.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2800lib.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index 22a1a8f..6bdf6d6 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -3949,7 +3949,7 @@ int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
>        case RT5390:
>                break;
>        default:
> -               ERROR(rt2x00dev, "Invalid RT chipset detected.\n");
> +               ERROR(rt2x00dev, "Invalid RT chipset 0x%04x detected.\n", rt2x00dev->chip.rt);
>                return -ENODEV;
>        }
>
> @@ -3968,7 +3968,7 @@ int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
>        case RF5390:
>                break;
>        default:
> -               ERROR(rt2x00dev, "Invalid RF chipset 0x%x detected.\n",
> +               ERROR(rt2x00dev, "Invalid RF chipset 0x%04x detected.\n",
>                      rt2x00dev->chip.rf);
>                return -ENODEV;
>        }
> --
> 1.7.6.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

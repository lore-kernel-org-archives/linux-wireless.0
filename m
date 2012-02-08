Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:41079 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756163Ab2BHNkO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Feb 2012 08:40:14 -0500
Received: by pbcun15 with SMTP id un15so569751pbc.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Feb 2012 05:40:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1328707524-11415-1-git-send-email-john.li.mediatek@gmail.com>
References: <1328707524-11415-1-git-send-email-john.li.mediatek@gmail.com>
Date: Wed, 8 Feb 2012 14:34:17 +0100
Message-ID: <CAGXE3d-DRyJyQA+G=-oS+oFd6BQh6f+6C=_NREDgy4FwkHdWeQ@mail.gmail.com> (sfid-20120208_144020_556605_AD6E19CB)
Subject: Re: [PATCH] rt2x00:Add debug message for new chipset
From: Helmut Schaa <helmut.schaa@googlemail.com>
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

No objections from my side.

Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>

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

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:38687 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933677AbZDJQxd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Apr 2009 12:53:33 -0400
MIME-Version: 1.0
In-Reply-To: <15d0b9b20904100916u3ff85ff5gd7a989120b7c048f@mail.gmail.com>
References: <15d0b9b20904100916u3ff85ff5gd7a989120b7c048f@mail.gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Fri, 10 Apr 2009 18:53:16 +0200
Message-ID: <69e28c910904100953uc0c0811i6ea8dee19a956951@mail.gmail.com> (sfid-20090410_185339_728750_63EFE3F7)
Subject: Re: Additional USB identifier for otus driver [WN111v2]
To: Daniele Napolitano <dnax88@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	akpm@linux-foundation.org, gregkh@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 10, 2009 at 6:16 PM, Daniele Napolitano <dnax88@gmail.com> =
wrote:
> This is a patch for Otus driver [Atheros 9k series] that provide
> support for WN111v2 USB 802.11n
> adapter.
>
> Otus sources tree: OAL/Otus/Linux
>
> --- zdusb.h.orig =A0 =A0 =A0 =A02009-04-10 17:48:17.620423000 +0200
> +++ zdusb.h =A0 =A0 2009-04-10 17:54:41.356419568 +0200
> @@ -26,5 +26,9 @@
>
>
> =A0#define VENDOR_DLINK =A0 =A0 =A0 =A0 =A0 =A00x07D1 =A0//Dlink
>
> =A0#define PRODUCT_DWA160A =A0 =A0 =A0 =A0 0x3C10
>
> +
> +#define VENDOR_NETGEAR =A0 =A0 =A0 =A0 =A00x0846 =A0//NetGear
> +#define PRODUCT_WNDA3100 =A0 =A0 =A0 =A00x9010
> +#define PRODUCT_WN111v2 =A0 =A0 =A0 =A0 0x9001
>
>
> =A0#endif
>
>
> --- zdusb.c.orig =A0 =A0 =A0 =A02009-04-10 17:48:17.620423000 +0200
> +++ zdusb.c =A0 =A0 2009-04-10 17:53:15.316421516 +0200
> @@ -36,7 +36,8 @@
> =A0static struct usb_device_id zd1221_ids [] =3D {
>
> =A0 =A0 =A0 =A0{ USB_DEVICE(VENDOR_ATHR, PRODUCT_AR9170) },
>
> =A0 =A0 =A0 =A0 { USB_DEVICE(VENDOR_DLINK, PRODUCT_DWA160A) },
>
> - =A0 =A0 =A0 { USB_DEVICE(0x0846, 0x9010) },
>
> + =A0 =A0 =A0 { USB_DEVICE(VENDOR_NETGEAR, PRODUCT_WNDA3100) },
> + =A0 =A0 =A0 { USB_DEVICE(VENDOR_NETGEAR, PRODUCT_WN111v2) },
>
> =A0 =A0 =A0 =A0{ } =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 /* Terminating entry */
>
> =A0};
>
>
>
>
> --
> Daniele "DnaX" Napolitano
> https://launchpad.net/~dnax88
> http://dnax.netsons.org/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wirel=
ess" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Need the same for ar9170.

--=20
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.188]:13673 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbYHKVgM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Aug 2008 17:36:12 -0400
Received: by fk-out-0910.google.com with SMTP id 18so1952475fkq.5
        for <linux-wireless@vger.kernel.org>; Mon, 11 Aug 2008 14:36:09 -0700 (PDT)
Message-ID: <22bd28110808111436j7ba8a396h77cbc20f88337029@mail.gmail.com> (sfid-20080811_233616_546509_8D48AC63)
Date: Mon, 11 Aug 2008 23:36:08 +0200
From: "=?ISO-8859-1?Q?matthieu_Barth=E9lemy?=" <bonsouere@gmail.com>
To: "Larry Finger" <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] rtl8187: Add USB ID for Netgear WG111V3
Cc: "John W Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <489fbfb9.IY+WzjnFwKATbnw0%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <489fbfb9.IY+WzjnFwKATbnw0%Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks for your willingness to merge this patch. From what I know,
this device is very common so a lot of new users will potentially
benefit from the rtl8187B code.
Any news about a possible inclusion in 2.6.27?

Mathieu Barth=E9lemy



On 8/11/08, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> From: matthieu Barth=E9lemy <bonsouere@gmail.com>
>
> Add the USB ID for a Netgear WG111v3.
>
> Signed-off-by: matthieu Barth=E9lemy <bonsouere@gmail.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
>
> John,
>
> Technically, this is 2.6.28 material, but is it possible to push
> it for 2.6.27?
>
> Larry
> ---
>
> Index: wireless-testing/drivers/net/wireless/rtl8187_dev.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- wireless-testing.orig/drivers/net/wireless/rtl8187_dev.c
> +++ wireless-testing/drivers/net/wireless/rtl8187_dev.c
> @@ -37,6 +37,7 @@ static struct usb_device_id rtl8187_tabl
>  	{USB_DEVICE(0x0bda, 0x8187), .driver_info =3D DEVICE_RTL8187},
>  	{USB_DEVICE(0x0bda, 0x8189), .driver_info =3D DEVICE_RTL8187B},
>  	{USB_DEVICE(0x0bda, 0x8197), .driver_info =3D DEVICE_RTL8187B},
> +	{USB_DEVICE(0x0846, 0x4260), .driver_info =3D DEVICE_RTL8187B},
>  	/* Netgear */
>  	{USB_DEVICE(0x0846, 0x6100), .driver_info =3D DEVICE_RTL8187},
>  	{USB_DEVICE(0x0846, 0x6a00), .driver_info =3D DEVICE_RTL8187},
>
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:61538 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754511Ab2IBUha (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Sep 2012 16:37:30 -0400
MIME-Version: 1.0
In-Reply-To: <1346433734-3337-2-git-send-email-gwingerde@gmail.com>
References: <1346433734-3337-1-git-send-email-gwingerde@gmail.com>
	<1346433734-3337-2-git-send-email-gwingerde@gmail.com>
Date: Sun, 2 Sep 2012 22:37:30 +0200
Message-ID: <CAOZOX0X920egxb_avqNZbe=AodVTtmEN4+XEKDLe4=98UzByqQ@mail.gmail.com> (sfid-20120902_223733_947990_61C8B51A)
Subject: Re: [PATCH v2 1/6] rt2x00: Identify ASUS USB-N53 device.
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	users@rt2x00.serialmonkey.com,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Maximilian Engelhardt <maxi@daemonizer.de>,
	stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 31, 2012 at 7:22 PM, Gertjan van Wingerde
<gwingerde@gmail.com> wrote:
> This is an RT3572 based device.
>
> Signed-off-by: Maximilian Engelhardt <maxi@daemonizer.de>
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
> Cc: <stable@vger.kernel.org>

Acked-by: Ivo van Doorn@gmail.com>


> diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
> index 6cf3365..6681bfc 100644
> --- a/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -1157,6 +1157,8 @@ static struct usb_device_id rt2800usb_device_table[] = {
>         { USB_DEVICE(0x1690, 0x0744) },
>         { USB_DEVICE(0x1690, 0x0761) },
>         { USB_DEVICE(0x1690, 0x0764) },
> +       /* ASUS */
> +       { USB_DEVICE(0x0b05, 0x179d) },
>         /* Cisco */
>         { USB_DEVICE(0x167b, 0x4001) },
>         /* EnGenius */
> @@ -1222,7 +1224,6 @@ static struct usb_device_id rt2800usb_device_table[] = {
>         { USB_DEVICE(0x0b05, 0x1760) },
>         { USB_DEVICE(0x0b05, 0x1761) },
>         { USB_DEVICE(0x0b05, 0x1790) },
> -       { USB_DEVICE(0x0b05, 0x179d) },
>         /* AzureWave */
>         { USB_DEVICE(0x13d3, 0x3262) },
>         { USB_DEVICE(0x13d3, 0x3284) },
> --
> 1.7.11.1
>

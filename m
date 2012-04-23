Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:65009 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754273Ab2DWJ73 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2012 05:59:29 -0400
Received: by lahj13 with SMTP id j13so8979723lah.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 Apr 2012 02:59:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1334672885-8161-1-git-send-email-xose.vazquez@gmail.com>
References: <1334672885-8161-1-git-send-email-xose.vazquez@gmail.com>
Date: Mon, 23 Apr 2012 11:59:27 +0200
Message-ID: <CAL1gcdOrMXMLbgJRJLWzg10+E0kqabA82ZsdF01Rua8keQ6yLw@mail.gmail.com> (sfid-20120423_115932_611646_CD27DF4F)
Subject: Re: [PATCH] wireless: rt2x00: rt2800usb more devices were identified
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	IvDoorn@gmail.com, linville@tuxdriver.com,
	helmut.schaa@googlemail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 17, 2012 at 4:28 PM, Xose Vazquez Perez
<xose.vazquez@gmail.com> wrote:
> found in 2012_03_22_RT5572_Linux_STA_v2.6.0.0_DPO
>
> RT3070:
> (0x2019,0x5201)  Planex Communications, Inc. RT8070
> (0x7392,0x4085)  2L Central Europe BV 8070
> 7392 is Edimax
>
> RT35xx:
> (0x1690,0x0761) Askey
> was Fujitsu Stylistic 550, but 1690 is Askey
>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2800usb.c |    8 +++-----
>  1 files changed, 3 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
> index 5851be7..5601302 100644
> --- a/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -992,6 +992,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
>        /* DVICO */
>        { USB_DEVICE(0x0fe9, 0xb307) },
>        /* Edimax */
> +       { USB_DEVICE(0x7392, 0x4085) },
>        { USB_DEVICE(0x7392, 0x7711) },
>        { USB_DEVICE(0x7392, 0x7717) },
>        { USB_DEVICE(0x7392, 0x7718) },
> @@ -1067,6 +1068,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
>        /* Philips */
>        { USB_DEVICE(0x0471, 0x200f) },
>        /* Planex */
> +       { USB_DEVICE(0x2019, 0x5201) },
>        { USB_DEVICE(0x2019, 0xab25) },
>        { USB_DEVICE(0x2019, 0xed06) },
>        /* Quanta */
> @@ -1150,6 +1152,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
>        { USB_DEVICE(0x8516, 0x3572) },
>        /* Askey */
>        { USB_DEVICE(0x1690, 0x0744) },
> +       { USB_DEVICE(0x1690, 0x0761) },
>        { USB_DEVICE(0x1690, 0x0764) },
>        /* Cisco */
>        { USB_DEVICE(0x167b, 0x4001) },
> @@ -1235,12 +1238,8 @@ static struct usb_device_id rt2800usb_device_table[] = {
>        { USB_DEVICE(0x07d1, 0x3c0b) },
>        { USB_DEVICE(0x07d1, 0x3c17) },
>        { USB_DEVICE(0x2001, 0x3c17) },
> -       /* Edimax */
> -       { USB_DEVICE(0x7392, 0x4085) },
>        /* Encore */
>        { USB_DEVICE(0x203d, 0x14a1) },
> -       /* Fujitsu Stylistic 550 */
> -       { USB_DEVICE(0x1690, 0x0761) },
>        /* Gemtek */
>        { USB_DEVICE(0x15a9, 0x0010) },
>        /* Gigabyte */
> @@ -1261,7 +1260,6 @@ static struct usb_device_id rt2800usb_device_table[] = {
>        { USB_DEVICE(0x05a6, 0x0101) },
>        { USB_DEVICE(0x1d4d, 0x0010) },
>        /* Planex */
> -       { USB_DEVICE(0x2019, 0x5201) },
>        { USB_DEVICE(0x2019, 0xab24) },
>        /* Qcom */
>        { USB_DEVICE(0x18e8, 0x6259) },
> --
> 1.7.6.5
>



-- 
---
Gertjan

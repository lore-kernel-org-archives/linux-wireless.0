Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:48186 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143Ab1CPO2G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2011 10:28:06 -0400
Received: by ewy4 with SMTP id 4so444888ewy.19
        for <linux-wireless@vger.kernel.org>; Wed, 16 Mar 2011 07:28:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1300284739-7797-2-git-send-email-lemenkov@gmail.com>
References: <1300284739-7797-1-git-send-email-lemenkov@gmail.com>
	<1300284739-7797-2-git-send-email-lemenkov@gmail.com>
Date: Wed, 16 Mar 2011 15:28:04 +0100
Message-ID: <AANLkTima9_VSL4Db1RXSPLRXyoBOwdym9CkJUJrySnSC@mail.gmail.com>
Subject: Re: [PATCH 1/4] rt2x00: Add rt2870 device id
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Peter Lemenkov <lemenkov@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@redhat.com>,
	rt2x00-dev <users@rt2x00.serialmonkey.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/3/16 Peter Lemenkov <lemenkov@gmail.com>:
> Add ID for Asus USB-N11 Wi-FI adapter. Tested by me.
>
> Signed-off-by: Peter Lemenkov <lemenkov@gmail.com>
> ---
>  drivers/net/wireless/rt2x00/rt2800usb.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
> index 197a36c..03a5308 100644
> --- a/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -719,6 +719,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
>        { USB_DEVICE(0x0b05, 0x1732), USB_DEVICE_DATA(&rt2800usb_ops) },
>        { USB_DEVICE(0x0b05, 0x1742), USB_DEVICE_DATA(&rt2800usb_ops) },
>        { USB_DEVICE(0x0b05, 0x1784), USB_DEVICE_DATA(&rt2800usb_ops) },
> +       { USB_DEVICE(0x1761, 0x0b05), USB_DEVICE_DATA(&rt2800usb_ops) },
>        /* AzureWave */
>        { USB_DEVICE(0x13d3, 0x3247), USB_DEVICE_DATA(&rt2800usb_ops) },
>        { USB_DEVICE(0x13d3, 0x3273), USB_DEVICE_DATA(&rt2800usb_ops) },
> @@ -913,7 +914,6 @@ static struct usb_device_id rt2800usb_device_table[] = {
>        { USB_DEVICE(0x0b05, 0x1760), USB_DEVICE_DATA(&rt2800usb_ops) },
>        { USB_DEVICE(0x0b05, 0x1761), USB_DEVICE_DATA(&rt2800usb_ops) },
>        { USB_DEVICE(0x0b05, 0x1790), USB_DEVICE_DATA(&rt2800usb_ops) },
> -       { USB_DEVICE(0x1761, 0x0b05), USB_DEVICE_DATA(&rt2800usb_ops) },
>        /* AzureWave */
>        { USB_DEVICE(0x13d3, 0x3262), USB_DEVICE_DATA(&rt2800usb_ops) },
>        { USB_DEVICE(0x13d3, 0x3284), USB_DEVICE_DATA(&rt2800usb_ops) },

Either: the patch or title seems to be incorrect. It looks like you
just moved place where entry was typed...?

-- 
Rafał

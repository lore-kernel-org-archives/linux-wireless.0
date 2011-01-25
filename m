Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:43088 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827Ab1AYTei convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Jan 2011 14:34:38 -0500
Received: by qwa26 with SMTP id 26so127636qwa.19
        for <linux-wireless@vger.kernel.org>; Tue, 25 Jan 2011 11:34:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110125094229.GA16055@suse.de>
References: <20110125094229.GA16055@suse.de>
Date: Tue, 25 Jan 2011 20:34:36 +0100
Message-ID: <AANLkTinLUSR6NggAB-oYthnh5Bo7uBbBzgpqs+0oGV=5@mail.gmail.com>
Subject: Re: [PATCH] rt2x00: add device id for windy31 usb device
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	rf@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> From: Greg Kroah-Hartman <gregkh@suse.de>
>
> This patch adds the device id for the windy31 USB device to the rt73usb
> driver.
>
> Thanks to Ralf Flaxa for reporting this and providing testing and a
> sample device.
>
> Reported-by: Ralf Flaxa <rf@suse.de>
> Tested-by: Ralf Flaxa <rf@suse.de>
> Cc: stable <stable@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> --- a/drivers/net/wireless/rt2x00/rt73usb.c
> +++ b/drivers/net/wireless/rt2x00/rt73usb.c
> @@ -2446,6 +2446,7 @@ static struct usb_device_id rt73usb_device_table[] = {
>        { USB_DEVICE(0x04bb, 0x093d), USB_DEVICE_DATA(&rt73usb_ops) },
>        { USB_DEVICE(0x148f, 0x2573), USB_DEVICE_DATA(&rt73usb_ops) },
>        { USB_DEVICE(0x148f, 0x2671), USB_DEVICE_DATA(&rt73usb_ops) },
> +       { USB_DEVICE(0x0812, 0x3101), USB_DEVICE_DATA(&rt73usb_ops) },
>        /* Qcom */
>        { USB_DEVICE(0x18e8, 0x6196), USB_DEVICE_DATA(&rt73usb_ops) },
>        { USB_DEVICE(0x18e8, 0x6229), USB_DEVICE_DATA(&rt73usb_ops) },
>

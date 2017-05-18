Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33076 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752898AbdERFrJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 May 2017 01:47:09 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Tom =?utf-8?Q?Gaudasi=C5=84ski?= <tomg@records.headdesk.com.au>
Cc: linux-wireless@vger.kernel.org, sgruszka@redhat.com,
        helmut.schaa@googlemail.com
Subject: Re: [PATCH] rt2800usb: Add Epson wireless adapter device-id
References: <8e00714b-ab62-15e9-e86a-e0de5009797d@records.headdesk.com.au>
Date: Thu, 18 May 2017 08:47:03 +0300
In-Reply-To: <8e00714b-ab62-15e9-e86a-e0de5009797d@records.headdesk.com.au>
        ("Tom \=\?utf-8\?Q\?Gaudasi\=C5\=84ski\=22's\?\= message of "Wed, 17 May 2017
 20:15:30 +1000")
Message-ID: <87shk267jc.fsf@purkki.adurom.net> (sfid-20170518_074712_597337_DEE432D3)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tom Gaudasi=C5=84ski <tomg@records.headdesk.com.au> writes:

> Make Epson WN7512BEP work by adding its device-id to rt2800usb. Device
> contains a Ralink RT3071L, registers as vendor Accton/Arcadyan.
>
> Signed-off-by: Tom Gaudasinski <tomg@records.headdesk.com.au>

The prefix should be "rt2x00:".

> --- linux/drivers/net/wireless/ralink/rt2x00/rt2800usb.c.orig=20=20=20
> 2017-05-17 19:49:44.893895819 +1000
> +++ linux/drivers/net/wireless/ralink/rt2x00/rt2800usb.c    2017-05-17
> 19:49:32.906111192 +1000
> @@ -1156,6 +1156,8 @@ static struct usb_device_id rt2800usb_de
>      { USB_DEVICE(0x2001, 0x3c17) },
>      /* Panasonic */
>      { USB_DEVICE(0x083a, 0xb511) },
> +    /* Accton/Arcadyan/Epson */
> +    { USB_DEVICE(0x083a, 0xb512) },

The patch looks to be corrupted, didn't it test it though. Better use
'git send-email' to submit patches.

--=20
Kalle Valo

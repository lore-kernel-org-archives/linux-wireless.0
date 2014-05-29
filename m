Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:43587 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756219AbaE2LOy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2014 07:14:54 -0400
Received: by mail-pa0-f46.google.com with SMTP id kq14so205002pab.33
        for <linux-wireless@vger.kernel.org>; Thu, 29 May 2014 04:14:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <78e41a7f3d624575aa7feef3b002553c@SIXPR01MB256.apcprd01.prod.exchangelabs.com>
References: <78e41a7f3d624575aa7feef3b002553c@SIXPR01MB256.apcprd01.prod.exchangelabs.com>
Date: Thu, 29 May 2014 16:44:53 +0530
Message-ID: <CAJwzM1=_uOi_RvaQaxS=uZLLpqiNqObRYuyD-SaKnK77py2PZw@mail.gmail.com> (sfid-20140529_131457_374023_3B4899F5)
Subject: Re: Support for 88W8897 in 3.10.17 kernel
From: Avinash Patil <avinashapatil@gmail.com>
To: Krishnankutty Plachikkattle
	<Krishnankutty_Plachikkattle@mindtree.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Krishnan,

>Is there any open source driver that supports  NFC and Bluetooth in this SoC?
Yes; btmrvl.ko and btusb.ko would support PCIe-USB8897 BT
functionality. Please check CONFIG_BT_MRVL kernel configuration
parameter.
For NFC,  nfcmrvl.ko & nfcmrvl_usb.ko would support 8897 NFC
functionality. Please check for CONFIG_NFC_MRVL kernel configuration
parameter.

Thanks,
Avinash

On Thu, May 29, 2014 at 2:47 PM, Krishnankutty Plachikkattle
<Krishnankutty_Plachikkattle@mindtree.com> wrote:
> Hi Avinash,
>
>
>
> Greetings. We are starting a new product development with 88W8897.
>
>
>
> This time I am planning to use PCIe interface.
>
>
>
> I am using kernel version 3.10.17. Looks like mwifiex  driver needs minimal
> changes.
>
>
>
> Is there any open source driver that supports  NFC and Bluetooth in this
> SoC?
>
>
>
>
>
> Thanks in advance,
>
>
>
> Regards
>
> Krishnan
>
>
>
>
>
>
> ________________________________
>
> http://www.mindtree.com/email/disclaimer.html

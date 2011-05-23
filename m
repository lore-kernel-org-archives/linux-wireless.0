Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:39717 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647Ab1EWLmo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 May 2011 07:42:44 -0400
Received: by qyk7 with SMTP id 7so770269qyk.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 May 2011 04:42:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTimDsOvrHnLxYeFLmaXTAA7Fpyy+HA@mail.gmail.com>
References: <BANLkTimDsOvrHnLxYeFLmaXTAA7Fpyy+HA@mail.gmail.com>
Date: Mon, 23 May 2011 21:42:43 +1000
Message-ID: <BANLkTimC9=kp8vUjSuO7Dm6Us5oo6kOuJQ@mail.gmail.com> (sfid-20110523_134247_534735_6D89DC7A)
Subject: Re: Access Point on davinci dm365 board
From: linux newbie <linux.newbie79@gmail.com>
To: Boyan Penev <boyan.mp@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

some time back, I enabled hostapd with Edimax USB wireless card. It
runs on rt73 driver. You need to compile hostapd with libnl-2.0.


Thanks


On Mon, May 23, 2011 at 8:46 PM, Boyan Penev <boyan.mp@googlemail.com> wrote:
> Hello,
>
> i need to find a solution how to enable an embedded system (TI davinci
> board, dm365, arm CPU, kernel is 2.6.32.17 from the TI psp03.01.01.38
> sdk).
> Could someone advise me on what the most suitable solution might be? I
> know i should be using hostapd, but what would be the best wireless
> stick?
>
> Until now i have tried out the D-Link DWL-G122 and Linksys WUSB54GC-EU
> for the rt73usb driver is listed as supporting AP- mode, but i could
> not get tham to work:
> I've enabled the drivers as modules in the kernel, downloaded the
> firmware and loaded it in /lib/firmware, but the sticks don't get
> assigned as wireless interfaces.
> I've managed to enable an AVM wireless n stick with the ar9170 driver,
> but as ar9170 does not support ap mode- hostapd couldn't do anything.
>
> I will be very thankful for any help or advice on what the best stick
> for an embedded system as mine might be. Furthermore- is there any
> soulution
> for enabling the davinci board as an access point? i have 3 USB ports,
> a serial port and jtag available.
>
> Best Regards,
>
> Boyan Penev
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33579 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883Ab1EWKqk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 May 2011 06:46:40 -0400
Received: by fxm17 with SMTP id 17so3818437fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 May 2011 03:46:39 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 23 May 2011 12:46:39 +0200
Message-ID: <BANLkTimDsOvrHnLxYeFLmaXTAA7Fpyy+HA@mail.gmail.com> (sfid-20110523_124643_748510_033C917D)
Subject: Access Point on davinci dm365 board
From: Boyan Penev <boyan.mp@googlemail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

i need to find a solution how to enable an embedded system (TI davinci
board, dm365, arm CPU, kernel is 2.6.32.17 from the TI psp03.01.01.38
sdk).
Could someone advise me on what the most suitable solution might be? I
know i should be using hostapd, but what would be the best wireless
stick?

Until now i have tried out the D-Link DWL-G122 and Linksys WUSB54GC-EU
for the rt73usb driver is listed as supporting AP- mode, but i could
not get tham to work:
I've enabled the drivers as modules in the kernel, downloaded the
firmware and loaded it in /lib/firmware, but the sticks don't get
assigned as wireless interfaces.
I've managed to enable an AVM wireless n stick with the ar9170 driver,
but as ar9170 does not support ap mode- hostapd couldn't do anything.

I will be very thankful for any help or advice on what the best stick
for an embedded system as mine might be. Furthermore- is there any
soulution
for enabling the davinci board as an access point? i have 3 USB ports,
a serial port and jtag available.

Best Regards,

Boyan Penev

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:47893 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbaHAGO1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Aug 2014 02:14:27 -0400
Received: by mail-la0-f52.google.com with SMTP id e16so2811002lan.25
        for <linux-wireless@vger.kernel.org>; Thu, 31 Jul 2014 23:14:25 -0700 (PDT)
MIME-Version: 1.0
From: Rohit Kumar <rkthebest@gmail.com>
Date: Fri, 1 Aug 2014 15:14:05 +0900
Message-ID: <CABzetm1Q-BVLa_QUayPrytg1MHLyb+9+i=QAXHehAkY2hq8VFA@mail.gmail.com> (sfid-20140801_081602_390712_B6B5A9D8)
Subject: cross compiling RAlink rt2870 for ARM
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

i am trying to get my USB wifi dongle (based on ralink 2870 chipset) working.

i built the driver using the source.
modified Makefile to add kernel source and cross compiler
and os/linux/config.mk to include header files.

so when i load the module , it loads

and i can see the device when i use "iwconfig"

but when i try to bring it up "ifconfig wlan0 up"

it fails with following error on dmesg

[  126.940000] phy0 -> rt2x00lib_request_firmware: Info - Loading
firmware file 'rt2870.bin'.
[  126.940000] rt2800usb 1-1.2:1.0: firmware: requesting rt2870.bin
[  126.940000] PM: Adding info for No Bus:1-1.2:1.0
[  186.940000] PM: Removing info for No Bus:1-1.2:1.0
[  186.940000] phy0 -> rt2x00lib_request_firmware: Error - Failed to
request Firmware.
#

i have got the rt2870.bin file located in /lib/firmware
but i think driver cannot find it..
how do i solve this?


With Regards,

Rohit Kumar

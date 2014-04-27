Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:42213 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421AbaD0TO3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Apr 2014 15:14:29 -0400
Received: by mail-wi0-f182.google.com with SMTP id d1so4708956wiv.15
        for <linux-wireless@vger.kernel.org>; Sun, 27 Apr 2014 12:14:28 -0700 (PDT)
Message-ID: <535D5712.6000106@gmail.com> (sfid-20140427_211433_147022_4CD73884)
Date: Sun, 27 Apr 2014 21:14:26 +0200
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: linux-wireless@vger.kernel.org
Subject: Firmware(rtl8723befw.bin) for the Realtek 8723BE 802.11n PCI wireless(rtl8723be)
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Ahoy!

Firmware(rtl8723befw.bin) for the Realtek 8723BE 802.11n PCI
wireless(rtl8723be)
missing in the "Repository of firmware blobs for use with the Linux kernel".
https://git.kernel.org/cgit/linux/kernel/git/firmware/linux-firmware.git/tree/rtlwifi
rtl8723befw.bin?


$ modinfo rtl8723be
filename:
/lib/modules/3.15.0-0.rc2.git3.1.fc21.x86_64/kernel/drivers/net/wireless/rtlwifi/rtl8723be/rtl8723be.ko
firmware:       rtlwifi/rtl8723befw.bin
description:    Realtek 8723BE 802.11n PCI wireless
license:        GPL
...


However attending in the "Code for new variety of the 8723 PCI cards -
temp until code added to kernel"
https://github.com/lwfinger/rtl8723be/tree/master/firmware/rtlwifi
rtl8723befw.bin


poma


https://bugzilla.redhat.com/show_bug.cgi?id=1091753



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:33613 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751863Ab1CVWTw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Mar 2011 18:19:52 -0400
From: Bing Zhao <bzhao@marvell.com>
To: "Popa, Stefan A" <stefan.a.popa@intel.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Kiran Divekar <dkiran@marvell.com>,
	Frank Huang <frankh@marvell.com>
Date: Tue, 22 Mar 2011 15:11:09 -0700
Subject: RE: Marvell 88w8787 Linux Drivers for Wi-Fi and Bluetooth
Message-ID: <477F20668A386D41ADCC57781B1F704307FA7913B9@SC-VEXCH1.marvell.com>
References: <477F20668A386D41ADCC57781B1F704307FA7912D2@SC-VEXCH1.marvell.com>
In-Reply-To: <477F20668A386D41ADCC57781B1F704307FA7912D2@SC-VEXCH1.marvell.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[CC: linux-wireless and more people]

Hi Stefan,

> Hi Bing,
> 
> I am a software developer at Intel. Currently I am working with 88w8787 Marvell wireless chip.
> 
> I have found your Wi-Fi Linux driver and firmware for 88w8787. Is there a different Linux driver and
> firmware for 88w8787 Wi-Fi as the one available publicly?

We do have customized SD8787 driver/firmware for specific customers. But it is advised to use the upstream 'mwifiex' driver because the 'mwifiex' driver has been improved a lot based on the review comments from Johannes, John, and other people. 

> 
> I have some concerns about Bluetooth also and how does it work 88w8787 SDIO card on Linux.
> 
> Is it needed also for Bluetooth a special Linux driver and firmware as for Wi-Fi? Or this 88w8787
> SDIO card works directly in Linux with the firmware provided for Wi-Fi and with standard Linux BT
> SDIO driver?

Currently there is a Bluetooth driver called 'btmrvl' that works for SD8688 only. We plan to submit a patch to enable 'btmrvl' to support SD8787 Bluetooth. Both 'mwifiex' and 'btmrvl' drivers will share the same firmware image.

> 
> Can you help us with these questions?

Hope I answered your questions. Feel free to contact me if you have any more questions.

Best Regards,

Bing

> 
> Many thanks in advance for your help and support!
> 
> Have a nice day!
> 
> Best regards,
> 
> Stefan A. Popa
> Open Source Technology Center
> System Software Division Romania
> Desk: +40 31 86 04 721
> iNET: 8 845 1021


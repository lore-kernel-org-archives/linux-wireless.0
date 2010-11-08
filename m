Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:47464 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703Ab0KHQKu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Nov 2010 11:10:50 -0500
Received: by pvb32 with SMTP id 32so1273414pvb.19
        for <linux-wireless@vger.kernel.org>; Mon, 08 Nov 2010 08:10:50 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 8 Nov 2010 19:10:49 +0300
Message-ID: <AANLkTik+BWQdU4hhKN7yfgOdJuQXopvYr4Z59RTntqSW@mail.gmail.com>
Subject: Bringing up Marvell 88W8300
From: Denis Kirjanov <kirjanov@gmail.com>
To: andreamrl@tiscali.it
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	dwmw2@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Andrea and wireless folks!

I'm trying to bring up my WiFi card under Linux. I've found the code
for the mac80211 (mrv8kng).
My card is Asus Wi-Fi-Tv card (integrated tv capturing+WiFi adapter:
01:0f.0 Ethernet controller: Marvell Technology Group Ltd. 88W8335
[Libertas] 802.11b/g Wireless (rev 43).


My current problem is that I can't load the firmware on the chip.
There are two files (Win drivers) on the Asus CDROM:

denis@denis-desktop:~/Downloads$ ls -al CB55N50.sys CB55N51.sys
-rw-r--r-- 1 denis denis 297856 2005-04-16 13:27 CB55N50.sys
-rw-r--r-- 1 denis denis 297856 2005-04-16 13:26 CB55N51.sys

The FW cutter can't find the the main FW:
denis@denis-desktop:~/Downloads$ ./mrv8k_extract_fw CB55N51.sys
Bootloader found at 282088
Firmware not found

I also tried the firmware from the *BSD (malo firmware), but also
without success.

Current problem that after loading the 'main' firmware the
MRV_REG_STATUS register is not
equal to MRV_FW_SIGNATURE.


PS: Looks like that this tree no longer available
git://git.infradead.org/mrv8k.git :/

Thanks in advance.

-- 
Regards,
Denis

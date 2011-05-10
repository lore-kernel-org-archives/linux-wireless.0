Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:36705 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014Ab1EJCCf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2011 22:02:35 -0400
Received: by pvg12 with SMTP id 12so2616264pvg.19
        for <linux-wireless@vger.kernel.org>; Mon, 09 May 2011 19:02:35 -0700 (PDT)
Message-ID: <4DC89CB7.7030409@lwfinger.net> (sfid-20110510_040239_160328_6752D08D)
Date: Mon, 09 May 2011 21:02:31 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: wireless <linux-wireless@vger.kernel.org>
Subject: Firmware problem for iwl6000
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am helping a user on the openSUSE forum. His dmesg output is as follows:

 > iwlagn 0000:03:00.0: Detected Intel Wireless WiFi Link 6000 Series 2x2 AGN 
REV=0x74
 > iwlagn 0000:03:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
 > iwlagn 0000:03:00.0: irq 36 for MSI/MSI-X
 > phy0: Selected rate control algorithm 'iwl-agn-rs'
 > iwlagn 0000:03:00.0: firmware: requesting iwlwifi-6000-3.ucode
 > iwlagn 0000:03:00.0: iwlwifi-6000-3.ucode firmware file req failed: -2
 > iwlagn 0000:03:00.0: firmware: requesting iwlwifi-6000-2.ucode
 > iwlagn 0000:03:00.0: iwlwifi-6000-2.ucode firmware file req failed: -2
 > iwlagn 0000:03:00.0: firmware: requesting iwlwifi-6000-1.ucode
 > iwlagn 0000:03:00.0: iwlwifi-6000-1.ucode firmware file req failed: -2
 > iwlagn 0000:03:00.0: Could not read microcode: -2
 > iwlagn 0000:03:00.0: firmware: requesting iwlwifi-6000-3.ucode
 > iwlagn 0000:03:00.0: iwlwifi-6000-3.ucode firmware file req failed: -2
 > iwlagn 0000:03:00.0: firmware: requesting iwlwifi-6000-2.ucode
 > iwlagn 0000:03:00.0: iwlwifi-6000-2.ucode firmware file req failed: -2
 > iwlagn 0000:03:00.0: firmware: requesting iwlwifi-6000-1.ucode
 > iwlagn 0000:03:00.0: iwlwifi-6000-1.ucode firmware file req failed: -2
 > iwlagn 0000:03:00.0: Could not read microcode: -2
 > iwlagn 0000:03:00.0: firmware: requesting iwlwifi-6000-3.ucode
 > iwlagn 0000:03:00.0: iwlwifi-6000-3.ucode firmware file req failed: -2
 > iwlagn 0000:03:00.0: firmware: requesting iwlwifi-6000-2.ucode
 > iwlagn 0000:03:00.0: iwlwifi-6000-2.ucode firmware file req failed: -2
 > iwlagn 0000:03:00.0: firmware: requesting iwlwifi-6000-1.ucode
 > iwlagn 0000:03:00.0: iwlwifi-6000-1.ucode firmware file req failed: -2
 > iwlagn 0000:03:00.0: Could not read microcode: -2

The kernel in question is 2.6.37. The only firmware for the iwl6000 in the 
openSUSE packages is iwlwifi-6000-4.ucode, and that is all I find in linux-firmware.

What advice should I give? Apparently, he tried a link of iwlwifi-6000-3.ucode 
to the .4 variety, but got an invalid firmware message.

Thanks,

Larry


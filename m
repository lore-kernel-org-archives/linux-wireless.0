Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:57018 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753317AbaFHHWN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jun 2014 03:22:13 -0400
Received: from nebulos.localnet ([88.217.181.182]) by smtp.web.de (mrweb004)
 with ESMTPSA (Nemesis) id 0MSnyP-1XJD301GTd-00Rt8F for
 <linux-wireless@vger.kernel.org>; Sun, 08 Jun 2014 09:22:11 +0200
From: blue-t@web.de
To: linux-wireless@vger.kernel.org
Subject: What is the state of mt7610un mainline support?
Date: Sun, 08 Jun 2014 09:22:10 +0200
Message-ID: <7708158.pL1FsGGcj0@nebulos> (sfid-20140608_092558_949956_B46B390A)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

i recently bought an AVM!Wlan Stick AC 430 (ID 057c:8501 AVM GmbH) which 
currently doesn't work at all with 3.15 kernel.
A magnifying glass revealed that this device is using an mt7610un chipset.
I tried to add the device id to the mt7610u driver from 
http://www.mediatek.com/en/downloads/?sort=os but that didn't work out.
 
Mar  8 16:36:46 kernel: [  250.686059] usb 3-2: Product: FRITZ!WLAN USB Stick 
AC 430
Mar  8 16:36:47 kernel: [  251.684085] scsi 7:0:0:0: CD-ROM            FRITZ!   
WLAN selfinstall 1.00 PQ: 0 ANSI: 0 CCS
Mar  8 16:37:12 kernel: [  277.161689] usb 3-2: Product: FRITZ!WLAN AC 430
Mar  8 16:37:12 kernel: [  277.163995] ==>RT65xx_WLAN_ChipOnOff(): OnOff:1, 
Reset= 0, pAd->WlanFunCtrl:0x0, Reg-WlanFunCtrl=0xff000002
Mar  8 16:37:15 kernel: [  279.692549] ERROR!!! NICLoadFirmware failed, 
Status[=0x00000001]
 
The  firmware shipped with the official driver was copied to /lib/firmware first 
though.
Firmware loading wasn't required for the earlier devices from that 
manufacturer if i understand  the discussion in 
http://www.spinics.net/lists/linux-wireless/msg123246.html correctly.
Do we need a similiar fix here?
 
Regards
Sam
 


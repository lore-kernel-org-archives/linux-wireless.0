Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from col0-omc2-s3.col0.hotmail.com ([65.55.34.77]:43114 "EHLO
	col0-omc2-s3.col0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754558Ab1ELI4p convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 May 2011 04:56:45 -0400
Message-ID: <COL123-W396F135692DCC15555143F96890@phx.gbl> (sfid-20110512_105648_710282_7F8D2BC8)
From: Krzysztof Stankiewicz <krzysztof_stankiewicz@hotmail.com>
To: <linux-wireless@vger.kernel.org>
Subject: usb 1-1: Could not load firmware file zd1211/zd1211b_ub. Error
 number -2
Date: Thu, 12 May 2011 18:56:43 +1000
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Does anyone know how to make this go away?
Im on LPC3250 embedded, no matter where I put the firmawre on the FS I get this error;
(ofcourse one exists at /lib/firmware/zd1211/zd1211b_ub)


[root@nxp /]# usb 1-1: USB disconnect, address 3
usb 1-1: new full speed USB device using usb-ohci and address 4
usb 1-1: New USB device found, idVendor=0ace, idProduct=1215
usb 1-1: New USB device strings: Mfr=16, Product=32, SerialNumber=0
usb 1-1: Product: USB2.0 WLAN
usb 1-1: Manufacturer: ZyDAS
usb 1-1: reset full speed USB device using usb-ohci and address 4
zd1211rw 1-1:1.0: phy1


[root@nxp /]#
[root@nxp /]# ifconfig wlan0 up
usb 1-1: firmware: requesting zd1211/zd1211b_ub
usb 1-1: Could not load firmware file zd1211/zd1211b_ub. Error number -2
zd1211rw 1-1:1.0: couldn't load firmware. Error number -2
ifconfig: SIOCSIFFLAGS: No such file or directory



[root@nxp /]# ls /lib/firmware/zd1211/zd1211
/lib/firmware/zd1211/zd1211_ub     /lib/firmware/zd1211/zd1211b_ub
/lib/firmware/zd1211/zd1211_uph    /lib/firmware/zd1211/zd1211b_uph
/lib/firmware/zd1211/zd1211_uphm   /lib/firmware/zd1211/zd1211b_uphm
/lib/firmware/zd1211/zd1211_uphr   /lib/firmware/zd1211/zd1211b_uphr
/lib/firmware/zd1211/zd1211_ur     /lib/firmware/zd1211/zd1211b_ur
[root@nxp /]# ls /zd1211/zd1211
/zd1211/zd1211_ub     /zd1211/zd1211_ur     /zd1211/zd1211b_uphr
/zd1211/zd1211_uph    /zd1211/zd1211b_ub    /zd1211/zd1211b_ur
/zd1211/zd1211_uphm   /zd1211/zd1211b_uph
/zd1211/zd1211_uphr   /zd1211/zd1211b_uphm
[root@nxp /]# ls ./zd1211/zd1211
./zd1211/zd1211_ub     ./zd1211/zd1211_ur     ./zd1211/zd1211b_uphr
./zd1211/zd1211_uph    ./zd1211/zd1211b_ub    ./zd1211/zd1211b_ur
./zd1211/zd1211_uphm   ./zd1211/zd1211b_uph
./zd1211/zd1211_uphr   ./zd1211/zd1211b_uphm 		 	   		  
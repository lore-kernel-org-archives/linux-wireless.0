Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bay0-omc3-s28.bay0.hotmail.com ([65.54.246.228]:47457 "EHLO
	bay0-omc3-s28.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934402AbYBNBOw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2008 20:14:52 -0500
Message-ID: <BAY101-W101597BA2B1DDD58D6F497C8250@phx.gbl> (sfid-20080214_011505_642266_367AAAD1)
From: Adam Turk <bofh1234@hotmail.com>
To: <linux-wireless@vger.kernel.org>
Subject: kernel 2.6.25-rc1 and no /dev/rt73usb
Date: Wed, 13 Feb 2008 20:14:50 -0500
Content-Type: text/plain; charset=iso-8859-1
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hello,

I just compiled 2.6.25-rc1 so I could use my wireless card (ID 148f:257=
3 Ralink Technology, Corp. RT2501USB Wireless Adapter).  With 2.6.25-rc=
1 when I plug it in I don't get any error messages like I did with 2.6.=
24.  When I plug it in I get the following in /var/log/messages:
=46eb 13 19:06:31 (none) kernel: usb 1-1: new full speed USB device usi=
ng ohci_hcd and address 3
=46eb 13 19:06:31 (none) kernel: usb 1-1: configuration #1 chosen from =
1 choice
=46eb 13 19:06:31 (none) kernel: usb 1-1: New USB device found, idVendo=
r=3D148f, idProduct=3D2573
=46eb 13 19:06:31 (none) kernel: usb 1-1: New USB device strings: Mfr=3D=
1, Product=3D2, SerialNumber=3D0
=46eb 13 19:06:31 (none) kernel: usb 1-1: Product: 802.11 bg WLAN
=46eb 13 19:06:31 (none) kernel: usb 1-1: Manufacturer: Ralink
=46eb 13 19:06:31 (none) kernel: phy0 -> rt2x00_set_chip: Info - Chipse=
t detected - rt: 1300, rf: 0002, rev: 0002573a.
=46eb 13 19:06:31 (none) kernel: usbcore: registered new interface driv=
er rt73usb

However no rt73usb device is created.  Why isn't this working? =20

Thanks,

_________________________________________________________________
Climb to the top of the charts!=A0Play the word scramble challenge with=
 star power.
http://club.live.com/star_shuffle.aspx?icid=3Dstarshuffle_wlmailtextlin=
k_jan-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

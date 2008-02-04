Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bay0-omc3-s26.bay0.hotmail.com ([65.54.246.226]:42288 "EHLO
	bay0-omc3-s26.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751316AbYBDQJb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2008 11:09:31 -0500
Message-ID: <BAY101-W4222A12F4019C98589AB3EC8330@phx.gbl> (sfid-20080204_160935_682904_5E192C54)
From: Adam Turk <bofh1234@hotmail.com>
To: <linux-wireless@vger.kernel.org>
Subject: RE: rt73 driver doesn't work in 2.6.24
Date: Mon, 4 Feb 2008 11:09:30 -0500
Content-Type: text/plain; charset=iso-8859-1
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> This is a problem with mac80211 loading the wep encryption, did you l=
oad the arc4 module?
>
> Ivo

I just compiled a new 2.6.24 kernel with arc4 compiled into the kernel =
and still the driver gives the following output:

rt73usb 1-1:1.0: usb_probe_interface
rt73usb 1-1:1.0: usb_probe_interface - got id
ACPI: PCI Interrupt 0000:00:12.0[A] -> GSI 18 (level, low) -> IRQ 19
snd-ca0106: Model 1006 Rev 00000000 Serial 10061102
phy0 -> rt73usb_validate_eeprom: EEPROM recovery - NIC: 0xffef
phy0 -> rt73usb_validate_eeprom: EEPROM recovery - Led: 0xe000
phy0 -> rt73usb_validate_eeprom: EEPROM recovery - RSSI OFFSET BG: 0x00=
00
phy0 -> rt2x00_set_chip: Info - Chipset detected - rt: 1300, rf: 0002, =
rev: 0002 573a.
phy0: Selected rate control algorithm 'simple'
phy0: Failed to initialize wep
phy0 -> rt2x00lib_probe_dev: Error - Failed to initialize hw.
rt73usb: probe of 1-1:1.0 failed with error -12
usbcore: registered new interface driver rt73usb

Despite the statement about registering the new interface driver rt73us=
b, the interface is not created. Can someone please tell me what is wro=
ng and get a fix into 2.6.24.1?

Thanks,
Adam

_________________________________________________________________
Need to know the score, the latest news, or you need your Hotmail=AE-ge=
t your "fix".
http://www.msnmobilefix.com/Default.aspx-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

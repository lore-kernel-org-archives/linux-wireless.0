Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:47142 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753391AbZJLTTP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2009 15:19:15 -0400
Message-ID: <4AD380FA.4070306@gmx.de>
Date: Mon, 12 Oct 2009 21:18:18 +0200
From: Joerg Albert <jal2@gmx.de>
MIME-Version: 1.0
To: Frank Schaefer <schaefer.frank@gmx.net>
CC: otus-devel@lists.madwifi-project.org,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [otus-devel] Fritz!WLAN USB-Stick N: Firmware ?
References: <4AD328D5.3060905@gmx.net>
In-Reply-To: <4AD328D5.3060905@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/12/2009 03:02 PM, Frank Schaefer wrote:
> Hi,
> 
> I 've got a Fritz!WLAN USB-Stick N (057c:8401) yesterday, and syslog
> tells me that the driver can't find the firmware-file
> 
> usb 2-9: new high speed USB device using ehci_hcd and address 7
> usb 2-9: New USB device found, idVendor=057c, idProduct=8401
> usb 2-9: New USB device strings: Mfr=16, Product=32, SerialNumber=48
> usb 2-9: Product: FRITZ!WLAN USB Stick N
> usb 2-9: Manufacturer: AVM Berlin
> usb 2-9: SerialNumber: 001F3F048161
> usb 2-9: configuration #1 chosen from 1 choice
> usb 2-9: reset high speed USB device using ehci_hcd and address 7
> usb 2-9: firmware: requesting ar9170.fw
> usb 2-9: ar9170.fw firmware file not found, trying old firmware...
> usb 2-9: firmware: requesting ar9170-1.fw
> usb 2-9: file with init values not found.
> ar9170usb: probe of 2-9:1.0 failed with error -2
> usbcore: registered new interface driver ar9170usb
> 
> I'm using kernel 2.6.31.2.
> Where can I get the firmware from and will it be included in the kernel
> in the future ?

For the AVM stick you need the one-stage firmware (opposite to the "old" two-stage one) from
http://www.kernel.org/pub/linux/kernel/people/mcgrof/firmware/ar9170/ar9170.fw
as stated on the ar9170 driver's webpage (http://linuxwireless.org/en/users/Drivers/ar9170).
Check the md5sum after downloading.
I don't think it will ever be included into the kernel, rather into some Linux distribution package.

BTW, questions about the ar9170 driver are more likely to be answered on the linux-wireless mailing list, this one
is the list for the original driver made by Atheros.

HTH,
Joerg.

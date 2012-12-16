Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:47837 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295Ab2LPEA3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Dec 2012 23:00:29 -0500
Received: by mail-vc0-f174.google.com with SMTP id d16so5916319vcd.19
        for <linux-wireless@vger.kernel.org>; Sat, 15 Dec 2012 20:00:28 -0800 (PST)
Message-ID: <50CD4759.7090107@lwfinger.net> (sfid-20121216_050035_069773_A9AFD2D2)
Date: Sat, 15 Dec 2012 22:00:25 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Realtek RTL8192DU
References: <5087035E.9010609@lwfinger.net> <201212160254.11739.s.L-H@gmx.de>
In-Reply-To: <201212160254.11739.s.L-H@gmx.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/15/2012 07:54 PM, Stefan Lippers-Hollmann wrote:
>
> As I just got hold of a Realtek RTL8192DU device (DeLock 88540[1]), I'm
> curious if you had a go with a driver for this chipset. The vendor
> driver seems to have issues with 64 bit operation (and kernel 3.7).
>
> usb 3-1.1: new high-speed USB device number 6 using ehci_hcd
> usb 3-1.1: New USB device found, idVendor=0bda, idProduct=8194
> usb 3-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> usb 3-1.1: Product: 802.11n NIC
> usb 3-1.1: Manufacturer: Realtek
> usb 3-1.1: SerialNumber: 00e04c000001

Stefan,

I have made some progress with the driver merged into staging. In addition, I 
have fixed the problems with 64-bit operation and the lack of kernel_thread() in 
3.7 for driver rtl8192DU_linux_v4.0.0_5260.20120921. As I'm not sure the list 
wants to get the patch, I'll send it separately via private email.

Your tests will be useful as my device has USB ID 0bda:8193.

Larry



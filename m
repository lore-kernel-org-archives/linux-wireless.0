Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:65350 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754382Ab3JaOJY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Oct 2013 10:09:24 -0400
Date: Thu, 31 Oct 2013 15:08:43 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Gianfranco Costamagna <costamagnagianfranco@yahoo.it>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Edimax EW-7733UnD
Message-ID: <20131031140842.GA14212@redhat.com> (sfid-20131031_150927_427197_F8377B99)
References: <1382537927.62604.YahooMailNeo@web171801.mail.ir2.yahoo.com>
 <1382538469.7892.YahooMailNeo@web171805.mail.ir2.yahoo.com>
 <20131024112206.GB1677@redhat.com>
 <1382614336.89589.YahooMailNeo@web171804.mail.ir2.yahoo.com>
 <20131024113748.GD1677@redhat.com>
 <1383227814.41997.YahooMailNeo@web171801.mail.ir2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1383227814.41997.YahooMailNeo@web171801.mail.ir2.yahoo.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 31, 2013 at 01:56:54PM +0000, Gianfranco Costamagna wrote:
> put key in my pc
> [  471.585065] usb 2-1.2: new high-speed USB device number 11 using ehci-pci
> [  471.693762] usb 2-1.2: New USB device found, idVendor=7392, idProduct=7733
> [  471.693766] usb 2-1.2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> [  471.693768] usb 2-1.2: Product: 802.11 n WLAN
> [  471.693770] usb 2-1.2: Manufacturer: Ralink
> [  471.693771] usb 2-1.2: SerialNumber: 1.0
> 
> sudo modprobe rt2800usb
> 
> [  540.170899] usbcore: registered new interface driver rt2800usb
> 
> nothing works...
> 
> Can you please help me again?

Lack of firmware ? Also check if device support is really compiled in
the module - "modinfo rt2800usb | grep 7733" should show device id.

Stanislaw

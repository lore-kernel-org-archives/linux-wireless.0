Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.179]:8798 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754405AbXKQB1T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2007 20:27:19 -0500
Received: by py-out-1112.google.com with SMTP id u77so4539361pyb
        for <linux-wireless@vger.kernel.org>; Fri, 16 Nov 2007 17:27:18 -0800 (PST)
Message-ID: <43e72e890711161727x1c5d5dafu5883d900428182d9@mail.gmail.com> (sfid-20071117_012725_616663_B17E9852)
Date: Fri, 16 Nov 2007 20:27:18 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: libertas-dev@lists.infradead.org
Subject: Re: libertas ub8xxx - bcdDevice 30.06 - firmware issues?
Cc: "Stefano Brivio" <stefano.brivio@polimi.it>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890711161726m11682a2fwcaba31c2d093310f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <43e72e890711161726m11682a2fwcaba31c2d093310f@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry CC'd linux-kernel, meant linux-wireless ;)

On Nov 16, 2007 8:26 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> I have a USB libertas 1286:2001 with bcdDevice 30.06 (from lsusb -v).
> I tried downloading the firmware from marvell:
>
> https://www.marvell.com/drivers/driverDisplay.do?dId=160&pId=38
>
> renaming and to usb8388.bin and putting it in firmware dir. Is this
> the right firmware??
>
> Upon load this is what I get:
>
> 17:58 < mcgrof> usb8xxx: URB in failure status: -71
> 17:58 < mcgrof> usb 4-1: reset high speed USB device using ehci_hcd
> and address 3
> 17:58 < mcgrof> usb 4-1: reset high speed USB device using ehci_hcd
> and address 3
> 17:58 < mcgrof> usb 4-1: reset high speed USB device using ehci_hcd
> and address 3
> 17:58 < mcgrof> usb 4-1: reset high speed USB device using ehci_hcd
> and address 3
> 17:58 < mcgrof> usb 4-1: reset high speed USB device using ehci_hcd
> and address 3
> 17:58 < mcgrof> usb 4-1: reset high speed USB device using ehci_hcd
> and address 3
> 17:58 < mcgrof> usb 4-1: reset high speed USB device using ehci_hcd
> and address 3
> 17:58 < mcgrof> usb 4-1: reset high speed USB device using ehci_hcd
> and address 3
> 17:58 < mcgrof> usb 4-1: reset high speed USB device using ehci_hcd
> and address 3
> 17:58 < mcgrof> usb 4-1: reset high speed USB device using ehci_hcd
> and address 3
> 17:58 < mcgrof> usb 4-1: reset high speed USB device using ehci_hcd
> and address 3
> 17:58 < mcgrof> usb8xxx: probe of 4-1:1.0 failed with error -12
> 17:58 < mcgrof> usbcore: registered new interface driver usb8xxx
>
> I'm using the compatibility package from:
>
> http://linuxwireless.org/en/users/Download
>
> on 2.6.22. So this driver reflects what's on
> wireless2.6.git#everything. I tried looking on the wiki but well can't
> find much information. Can we please start adding some info about this
> driver to:
>
> http://linuxwireless.org/en/users/Drivers/libertas
>
>   Luis
>

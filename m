Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58786 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201Ab0BWOpl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2010 09:45:41 -0500
Date: Tue, 23 Feb 2010 09:45:03 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Fabrice Lamareille <fab128@sorengo.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: problem with WG511v1
Message-ID: <20100223144502.GA2928@tuxdriver.com>
References: <4B83B96A.6050605@sorengo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4B83B96A.6050605@sorengo.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 23, 2010 at 12:18:02PM +0100, Fabrice Lamareille wrote:
> Hello
>
> I have a NETGEAR WG511v1 wireless pcmcia card.
> It was working perfectly on fedora 11 with the prism54 driver and the  
> attached isl3890 firmware.
>
> Since fedora 12, the p54pci driver is enabled by default, but it does  
> not work with my card. I downloaded the right isl3886pci firmware on  
> your website, but the card does not start...
> With the old isl3890 renamed as isl3886pci, the kernel crashes.
> With the attachd isl3886pci firmware, which I extracted from the windows  
> driver with fwextract, it seems not to crash, but the card does not  
> appear in NetworkManager nor starts automaticaly...
>
> Thanks in advance for your help.

I'm not sure what you mean by "firmware on your website", but the
file you attached does not match what is linked here:

http://wireless.kernel.org/en/users/Drivers/p54#firmware

In the command-lines pasted below, 2.13.12.0.arm is the file downloaded
through the link for "PCI / PCMCIA" for kernels 2.6.29 and above at
the URL above and isl3886pci is the file you attached to your email
by that same name.

/tmp
[linville-t400.local]:> ls -l isl3886pci 2.13.12.0.arm 
-rw-rw-r-- 1 linville linville 29036 2010-02-23 09:39 2.13.12.0.arm
-rw------- 1 linville linville 29040 2010-02-23 09:39 isl3886pci

/tmp
[linville-t400.local]:> cmp 2.13.12.0.arm isl3886pci 
2.13.12.0.arm isl3886pci differ: byte 5, line 1

If you use the specified firmware, does the device work for you?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

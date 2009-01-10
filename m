Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f21.google.com ([209.85.218.21]:56720 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbZAJRhs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Jan 2009 12:37:48 -0500
Received: by bwz14 with SMTP id 14so30342937bwz.13
        for <linux-wireless@vger.kernel.org>; Sat, 10 Jan 2009 09:37:46 -0800 (PST)
Cc: bcm43xx-dev@lists.berlios.de, Michael Buesch <mb@bu3sch.de>,
	Gringoli PhD Gringoli <francesco.gringoli@ing.unibs.it>
Message-Id: <AE7A4FD8-1728-4CE2-8CC7-DCE699C3B6C9@gmail.com> (sfid-20090110_183801_974000_C746976B)
From: Lorenzo Nava <navalorenx@gmail.com>
To: linux-wireless@vger.kernel.org
In-Reply-To: <200901091206.09736.mb@bu3sch.de>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [b43] opensource firmware
Date: Sat, 10 Jan 2009 18:37:43 +0100
References: <200901091129.22708.mb@bu3sch.de> <200901091149.28683.mb@bu3sch.de> <9F70A0D3-6334-45FB-9DAF-263FE89C847E@ing.unibs.it> <200901091206.09736.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello everybody,

today I tried OpenFWWF with kernel 2.6.28 on a Siemens wifi device  
with Broadcom 4306 chipset:

BCM94306 802.11g (rev 03)
PHY: Analog 2, Type 2, Revision 2
Radio: Manuf 0x17F, Version 0x2050, Revision 2

I did some tests and everything seems to work fine.

I remember, once again, that OpenFWWF needs v480 initvals to work  
properly, and was tested on 2.6.27-rc5 kernel.

During firmware development we used these devices

Belkin PCMCIA 4306 card,
Siemens PCI 4306 card.
Belkin PCI 4306 card.
ASUSTeK PCI 4318 card.

and firmware seems to work fine. Everyone that is interested in  
testing OpenFWWF is welcome: please let us know if the firmware works  
correctly, and, if it doesn't, please report which kind of problems  
you had.

Michael please let us know which kind of problem you had with your  
device.

cheers

Lorenzo Nava.



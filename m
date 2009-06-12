Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f187.google.com ([209.85.216.187]:50500 "EHLO
	mail-px0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbZFLO7p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2009 10:59:45 -0400
Received: by pxi17 with SMTP id 17so691989pxi.33
        for <linux-wireless@vger.kernel.org>; Fri, 12 Jun 2009 07:59:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A326771.6030301@lwfinger.net>
References: <ec2083b20906120654j370e5bdo724a7c3b6d505a6c@mail.gmail.com>
	 <4A326771.6030301@lwfinger.net>
Date: Fri, 12 Jun 2009 09:59:46 -0500
Message-ID: <ec2083b20906120759x4a8c247eh61d1f6bdb6f194f6@mail.gmail.com>
Subject: Re: 4311 not detected at all
From: "Fabio A. Correa" <facorread@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: bcm43xx-dev@lists.berlios.de,
	wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/6/12 Larry Finger <Larry.Finger@lwfinger.net>:
> There are three areas in your dmesg output that attracted my attention:
>
> ACPI: BIOS bug: multiple APIC/MADT found, using 0
> ACPI: If "acpi_apic_instance=2" works better, notify linux-acpi@vger.kernel.org
>
> Have you tested this boot parameter?
> So, the BAR problem is preventing ssb from loading, thus b43 cannot
> function. If the "acpi_apic_instance=2" option does not fix the
> problem, then you need to post this problem on the Linux Kernel
> Mailing List.

I had tested this boot parameter, and it did not work better, so I did
not notify linux-acpi@vger.kernel.org.

> Later there is this output:
>
> pci 0000:00:1c.0: BAR 7: can't allocate resource
> pci 0000:00:1c.0: BAR 8: can't allocate resource
> pci 0000:00:1c.1: BAR 7: can't allocate resource
> pci 0000:00:1c.1: BAR 8: can't allocate resource
> pci 0000:00:1c.2: BAR 7: can't allocate resource
> pci 0000:00:1c.2: BAR 8: can't allocate resource
> pci 0000:06:00.0: BAR 0: can't allocate resource

I am very familiar with this output, I have been getting this for
years, related to the PCI express hardware; however ndiswrapper has no
problem with the resource allocation or hardware. It works fine.

> and later:
>
> b43-pci-bridge 0000:06:00.0: device not available because of BAR 0
> [0x000000-0x003fff] collisions
> b43-pci-bridge: probe of 0000:06:00.0 failed with error -22

> The bottom line is that a BIOS error is likely the problem with BAR
> allocation on your machine. Have you checked to see if an updated one
> is available?

Hey, I found an updated BIOS available in the HP site, obviously
requiring Windows. I had deleted those partitions, so I will get a
Windows hard disk/CD and try to flash it. I did not work under Wine...
I will keep you informed.

By the way, what is BAR?

-- 
Fabio Andrés Correa Durán
http://facorread.150m.com

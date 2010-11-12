Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64460 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757099Ab0KLNuo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 08:50:44 -0500
Received: by fxm6 with SMTP id 6so95043fxm.19
        for <linux-wireless@vger.kernel.org>; Fri, 12 Nov 2010 05:50:43 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Tim Blechmann <tim@klingt.org>
Subject: Re: rt61pci issue
Date: Fri, 12 Nov 2010 14:49:27 +0100
Cc: linux-wireless@vger.kernel.org
References: <ibgpgg$a5m$1@dough.gmane.org>
In-Reply-To: <ibgpgg$a5m$1@dough.gmane.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201011121449.27414.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Tim,

Am Donnerstag 11 November 2010 schrieb Tim Blechmann:
> cat /proc/interrupts |grep 16\: && sleep 1 && cat /proc/interrupts | grep 16\:
>   16:          0    5140126          0          0   IO-APIC-fasteoi   
> uhci_hcd:usb3, ahci, 0000:08:00.0
>   16:          0    5140357          0          0   IO-APIC-fasteoi   
> uhci_hcd:usb3, ahci, 0000:08:00.0

Ehm, one more thing: are you sure irq 16 is used for rt61pci. At least
that part of /proc/interrupts suggests that irq 16 is somehow USB related.

Could you check which irq is assigned to rt61pci?
Can you reproduce the hangs without rt61pci as well?

Helmut

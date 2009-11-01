Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:46704 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775AbZKAPam convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Nov 2009 10:30:42 -0500
Received: by fg-out-1718.google.com with SMTP id 16so2366161fgg.1
        for <linux-wireless@vger.kernel.org>; Sun, 01 Nov 2009 07:30:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4888b8cb0911010451w3e824921ob5ee6b7aae5b728b@mail.gmail.com>
References: <4888b8cb0911010451w3e824921ob5ee6b7aae5b728b@mail.gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Sun, 1 Nov 2009 16:30:26 +0100
Message-ID: <69e28c910911010730i2afcf1b9o79063f6c6f37c678@mail.gmail.com>
Subject: Re: b43 with 14e4 gives DMA error
To: Thomas Wiecki <thomas.wiecki@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 1, 2009 at 1:51 PM, Thomas Wiecki
<thomas.wiecki@googlemail.com> wrote:
> 0c:00.0 Network controller [0280]: Broadcom Corporation BCM4312
> 802.11b/g [14e4:4315] (rev 01)
>        Subsystem: Dell Device [1028:000c]
>        Flags: bus master, fast devsel, latency 0, IRQ 17
>        Memory at f1ffc000 (64-bit, non-prefetchable) [size=16K]
>        Capabilities: <access denied>
>        Kernel driver in use: wl
>        Kernel modules: wl, ssb
>
> A variable delay after loading the most recent b43 driver I get a lot
> of (I hope last nights patches would have fixed the problems, but they
> didn't):
> [ 6895.111946] b43-phy0 ERROR: Fatal DMA error: 0x00000800,
> 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000
> [ 6895.111955] b43-phy0: Controller RESET (DMA error) ...
> [ 6895.336490] b43-phy0: Loading firmware version 478.104 (2008-07-01 00:50:23)
> [ 6900.841372] b43-phy0: Controller restarted
>
> After installing the driver for the first time, I have a few minutes I
> can use the wifi card, after that the DMA errors start to occur. Once
> they occured after the first loading, they appear immediatly after
> each loading.
>
> Ubuntu 9.04 (most recent) with kernel 2.6.31-14-generic
>
> Laptop is Dell E6500.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Does noacpi/noapic or blacklisting module "processor" have any effect on this?

Also, is this on PhoenixBIOS?

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)

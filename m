Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:35674 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754084AbcK1L02 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Nov 2016 06:26:28 -0500
MIME-Version: 1.0
In-Reply-To: <20161128075712.10785-1-jslaby@suse.cz>
References: <20161128075712.10785-1-jslaby@suse.cz>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Mon, 28 Nov 2016 12:26:26 +0100
Message-ID: <CACna6ry+1DxU+3GfSqfKJSOy6Mw4MRsgE-nu3KDMxk8ktkxS5A@mail.gmail.com> (sfid-20161128_122654_994401_4904AD2B)
Subject: Re: [PATCH] bcma: add Dell Inspiron 3148
To: Jiri Slaby <jslaby@suse.cz>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 28 November 2016 at 08:57, Jiri Slaby <jslaby@suse.cz> wrote:
> This is what is in the laptop:
> 01:00.0 Network controller [0280]: Broadcom Limited BCM43142 802.11b/g/n =
[14e4:4365] (rev 01)
>         Subsystem: Dell Device [1028:0018]
>         Flags: bus master, fast devsel, latency 0, IRQ 18
>         Memory at b0400000 (64-bit, non-prefetchable) [size=3D32K]
>         Capabilities: [40] Power Management version 3
>         Capabilities: [58] Vendor Specific Information: Len=3D78 <?>
>         Capabilities: [48] MSI: Enable- Count=3D1/1 Maskable- 64bit+
>         Capabilities: [d0] Express Endpoint, MSI 00
>         Capabilities: [100] Advanced Error Reporting
>         Capabilities: [13c] Virtual Channel
>         Capabilities: [160] Device Serial Number 00-00-9a-ff-ff-f3-40-b8
>         Capabilities: [16c] Power Budgeting <?>
>
> With the patch, I can see:
> bcma: bus0: Found chip with id 43142, rev 0x01 and package 0x08
> bcma: bus0: Core 0 found: ChipCommon (manuf 0x4BF, id 0x800, rev 0x28, cl=
ass 0x0)
> bcma: bus0: Core 1 found: IEEE 802.11 (manuf 0x4BF, id 0x812, rev 0x21, c=
lass 0x0)
> bcma: bus0: Core 2 found: PCIe (manuf 0x4BF, id 0x820, rev 0x16, class 0x=
0)
> bcma: bus0: Core 3 found: UNKNOWN (manuf 0x43B, id 0x368, rev 0x00, class=
 0x0)
> bcma: bus0: Bus registered
>
> The wifi is not currently supported by brcmsmac yet:
> brcmsmac bcma1:1: mfg 4bf core 812 rev 33 class 0 irq 18
> brcmsmac: unknown device id 4365
>
> So don't expect a working wifi from this patch :).
>
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com>
> Cc: <linux-wireless@vger.kernel.org>

Looks good, thanks.

--=20
Rafa=C5=82

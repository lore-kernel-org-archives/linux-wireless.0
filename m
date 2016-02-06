Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:36666 "EHLO
	mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbcBFAlD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Feb 2016 19:41:03 -0500
Received: by mail-io0-f172.google.com with SMTP id g73so146442039ioe.3
        for <linux-wireless@vger.kernel.org>; Fri, 05 Feb 2016 16:41:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56B53603.4080905@sieb.net>
References: <56B53603.4080905@sieb.net>
Date: Sat, 6 Feb 2016 01:41:02 +0100
Message-ID: <CACna6rxJFo-rtUP6g3LGn-e3fwF==OkVtBo41iLxKoWY=ETYRA@mail.gmail.com> (sfid-20160206_014138_013022_CC2142E9)
Subject: Re: BCM43142 doesn't work
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Samuel Sieb <samuel@sieb.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6 February 2016 at 00:53, Samuel Sieb <samuel@sieb.net> wrote:
> However, what happens is:
> Feb 04 11:55:50 localhost kernel: bcma: bus0: Found chip with id 43142, rev
> 0x01 and package 0x08
> Feb 04 11:55:50 localhost kernel: bcma: bus0: Core 0 found: ChipCommon
> (manuf 0x4BF, id 0x800, rev 0x28, class 0x0)
> Feb 04 11:55:50 localhost kernel: bcma: bus0: Core 1 found: IEEE 802.11
> (manuf 0x4BF, id 0x812, rev 0x21, class 0x0)
> Feb 04 11:55:50 localhost kernel: bcma: bus0: Core 2 found: PCIe (manuf
> 0x4BF, id 0x820, rev 0x16, class 0x0)
> Feb 04 11:55:50 localhost kernel: bcma: bus0: Core 3 found: UNKNOWN (manuf
> 0x43B, id 0x368, rev 0x00, class 0x0)
> Feb 04 11:55:50 localhost kernel: bcma: bus0: Bus registered

Which means bcma (bus!) supports BCM43132. It detects bus (!) devices
correctly and registers them. There is no driver supporting wireless
device found on this chipset.

It's a bit like having support for PCI bus. You still need driver for
various devices that can be found/connected to such bus.

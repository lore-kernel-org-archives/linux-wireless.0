Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:38091 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576Ab1GFLPW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2011 07:15:22 -0400
Received: by pvg12 with SMTP id 12so5938846pvg.19
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jul 2011 04:15:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E143FCF.8030201@darav.de>
References: <4E143FCF.8030201@darav.de>
Date: Wed, 6 Jul 2011 13:15:21 +0200
Message-ID: <CAL1gcdNwooP+nQwtgOSqwnPcO=JozzeEyMMC7shM9nhS954E1A@mail.gmail.com> (sfid-20110706_131525_929931_DD07AB78)
Subject: Re: RALINK rt2800pci , Patch for Device [1814:539f]
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Carsten Rietzschel <cr7@darav.de>, IvDoorn@gmail.com
Cc: helmut.schaa@googlemail.com, linux-wireless@vger.kernel.org,
	users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 6, 2011 at 12:58 PM, Carsten Rietzschel <cr7@darav.de> wrote:
> Hello together,
>
> attached find a small patch for the RALINK wireless driver.
> It's just adding one PCI-ID for:
>
> 02:00.0 Network controller [0280]: Ralink corp. Device [1814:539f]
>    Subsystem: Hewlett-Packard Company Device [103c:1637]
>    Flags: bus master, fast devsel, latency 0, IRQ 17
>    Memory at f0100000 (32-bit, non-prefetchable) [size=64K]
>    Capabilities: [40] Power Management version 3
>    Capabilities: [50] MSI: Enable- Count=1/32 Maskable- 64bit+
>    Capabilities: [70] Express Endpoint, MSI 00
>    Capabilities: [100] Advanced Error Reporting
>    Capabilities: [140] Device Serial Number 00-00-b2-7f-05-da-f8-c0
>    Kernel driver in use: rt2800pci
>    Kernel modules: rt2800pci
>
> It's for instance used in the HP DM1Z (Fusion) Netbook.
> I use this patch now for several weeks - starting with 2.3.29 up to
> 3.0-rc2 kernel. No problems so far.
>
> *Signed*-*off*-by: Carsten Rietzschel <cr7 [at] darav [dot] de>

This device ID has already been added in the latest rt2x00.git tree via patch:
http://git.kernel.org/?p=linux/kernel/git/ivd/rt2x00.git;a=commit;h=c56a574019a75c1ca36c540a8ab092a7ed35020d

However, this hasn't been propagated to the wireless tree yet.

Ivo, when are you planning to submit all pending patches towards the
wireless tree?

---
Gertjan.

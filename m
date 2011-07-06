Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:50291 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337Ab1GFLCg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2011 07:02:36 -0400
Received: by gxk21 with SMTP id 21so2576846gxk.19
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jul 2011 04:02:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E143FCF.8030201@darav.de>
References: <4E143FCF.8030201@darav.de>
Date: Wed, 6 Jul 2011 13:02:35 +0200
Message-ID: <CAGXE3d-nsc3qS1pyayUqZg9AB-572FFhoB+r_ZWP9B6n=xhYHA@mail.gmail.com> (sfid-20110706_130239_808581_D61AB296)
Subject: Re: RALINK rt2800pci , Patch for Device [1814:539f]
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Carsten Rietzschel <cr7@darav.de>
Cc: IvDoorn@gmail.com, gwingerde@gmail.com,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Nice.

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

That should be "Signed-off-by:". Mind to resubmit?

Otherwise no objections from my side :)
Helmut

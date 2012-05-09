Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4538 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757184Ab2EIHZu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 May 2012 03:25:50 -0400
Message-ID: <4FAA1BEF.10704@broadcom.com> (sfid-20120509_092554_255229_2CB795B7)
Date: Wed, 9 May 2012 09:25:35 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Brent Roman" <brent@mbari.org>
cc: linux-wireless@vger.kernel.org
Subject: Re: After Kernel 3.3, brcmsmac won't work on mid-2010 Mac Mini
References: <4FA9A8FE.5000102@mbari.org>
In-Reply-To: <4FA9A8FE.5000102@mbari.org>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/09/2012 01:15 AM, Brent Roman wrote:
> Hi,
> 
> When I updated to Linux Kernel 3.3.5 on my mid-2010 Aluminum Unibody Mac
> Mini,
> its built-in wireless was no longer recognized:
> 
> 03:00.0 Network controller [0280]: Broadcom Corporation BCM43224
> 802.11a/b/g/n [14e4:4353] (rev 01)
>     Subsystem: Apple Computer Inc. Device [106b:0093]
>     Flags: bus master, fast devsel, latency 0, IRQ 22
>     Memory at d3300000 (64-bit, non-prefetchable) [size=16K]
>     Capabilities: [40] Power Management version 3
>     Capabilities: [58] Vendor Specific Information: Len=78 <?>
>     Capabilities: [48] MSI: Enable- Count=1/1 Maskable- 64bit+
>     Capabilities: [d0] Express Endpoint, MSI 00
>     Capabilities: [100] Advanced Error Reporting
>     Capabilities: [13c] Virtual Channel
>     Capabilities: [160] Device Serial Number 54-70-4b-ff-ff-0c-60-33
>     Capabilities: [16c] Power Budgeting <?>
>     Kernel driver in use: brcmsmac
> 
> I tried kernel 3.3.0 with the same negative result.
> When I reverted to 3.2.16, the chip was immediately recognized.
> The driver in 3.3+ is loading the bcma module.
> 
> I've fine with running 3.2.16 for now.
> Is this a known problem?  A configuration error on my part?
> 
> Just let me know if you'd like me to try anything to help debug this
> (possible) regression.
> 

Any log on 3.3 kernel may help. Do you have bcma blacklisted in your
system? Do you have built the kernel yourself? Can you sent the .config
for both kernels?

Gr. AvS


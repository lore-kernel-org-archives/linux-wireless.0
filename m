Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from slush.shore.mbari.org ([134.89.12.31]:35705 "EHLO
	slush.shore.mbari.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755581Ab2EHXWe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 May 2012 19:22:34 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by slush.shore.mbari.org (Postfix) with ESMTP id 7307345E001
	for <linux-wireless@vger.kernel.org>; Tue,  8 May 2012 16:15:15 -0700 (PDT)
Received: from slush.shore.mbari.org ([127.0.0.1])
	by localhost (slush.shore.mbari.org [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7ENg-G30Aznd for <linux-wireless@vger.kernel.org>;
	Tue,  8 May 2012 16:15:15 -0700 (PDT)
Received: from [134.89.10.31] (pippin.shore.mbari.org [134.89.10.31])
	by slush.shore.mbari.org (Postfix) with ESMTPSA id 2CDCA6A400A
	for <linux-wireless@vger.kernel.org>; Tue,  8 May 2012 16:15:15 -0700 (PDT)
Message-ID: <4FA9A8FE.5000102@mbari.org> (sfid-20120509_012237_823738_39A56B38)
Date: Tue, 08 May 2012 16:15:10 -0700
From: Brent Roman <brent@mbari.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: After Kernel 3.3, brcmsmac won't work on mid-2010 Mac Mini
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

When I updated to Linux Kernel 3.3.5 on my mid-2010 Aluminum Unibody Mac 
Mini,
its built-in wireless was no longer recognized:

03:00.0 Network controller [0280]: Broadcom Corporation BCM43224 
802.11a/b/g/n [14e4:4353] (rev 01)
     Subsystem: Apple Computer Inc. Device [106b:0093]
     Flags: bus master, fast devsel, latency 0, IRQ 22
     Memory at d3300000 (64-bit, non-prefetchable) [size=16K]
     Capabilities: [40] Power Management version 3
     Capabilities: [58] Vendor Specific Information: Len=78 <?>
     Capabilities: [48] MSI: Enable- Count=1/1 Maskable- 64bit+
     Capabilities: [d0] Express Endpoint, MSI 00
     Capabilities: [100] Advanced Error Reporting
     Capabilities: [13c] Virtual Channel
     Capabilities: [160] Device Serial Number 54-70-4b-ff-ff-0c-60-33
     Capabilities: [16c] Power Budgeting <?>
     Kernel driver in use: brcmsmac

I tried kernel 3.3.0 with the same negative result.
When I reverted to 3.2.16, the chip was immediately recognized.
The driver in 3.3+ is loading the bcma module.

I've fine with running 3.2.16 for now.
Is this a known problem?  A configuration error on my part?

Just let me know if you'd like me to try anything to help debug this 
(possible) regression.

- brent


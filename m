Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lvps46-163-74-235.dedicated.hosteurope.de ([46.163.74.235]:44811
	"EHLO lvps46-163-74-235.dedicated.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752136Ab1GFLWp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2011 07:22:45 -0400
Message-ID: <4E144581.6000708@darav.de> (sfid-20110706_132257_927779_63DDF1A8)
Date: Wed, 06 Jul 2011 13:22:41 +0200
From: Carsten Rietzschel <cr7@darav.de>
MIME-Version: 1.0
To: Julian Calaby <julian.calaby@gmail.com>
CC: Helmut Schaa <helmut.schaa@googlemail.com>, IvDoorn@gmail.com,
	gwingerde@gmail.com, linux-wireless@vger.kernel.org,
	users@rt2x00.serialmonkey.com
Subject: Re: RALINK rt2800pci , Patch for Device [1814:539f]
References: <4E143FCF.8030201@darav.de> <CAGXE3d-nsc3qS1pyayUqZg9AB-572FFhoB+r_ZWP9B6n=xhYHA@mail.gmail.com> <CAGRGNgUPOEFwpeuy4ASv8wYOa9_9ZzUGokpF-CvwNXpBZ0AS8Q@mail.gmail.com>
In-Reply-To: <CAGRGNgUPOEFwpeuy4ASv8wYOa9_9ZzUGokpF-CvwNXpBZ0AS8Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks,

here we go with a changed Signed-off-by-Line.
In case it's usefull even it's already in the git-tree.

Signed-off-by: Carsten Rietzschel <cr7@darav.de>

diff -ur linux-3.0_rc2/drivers/net/wireless/rt2x00/rt2800pci.c
linux-3.0_rc2_patched/drivers/net/wireless/rt2x00/rt2800pci.c
--- linux-3.0_rc2/drivers/net/wireless/rt2x00/rt2800pci.c    2011-07-06
12:46:13.251676122 +0200
+++ linux-3.0_rc2_patched/drivers/net/wireless/rt2x00/rt2800pci.c   
2011-07-06 12:44:38.381673254 +0200
@@ -1158,6 +1158,7 @@
 #endif
 #ifdef CONFIG_RT2800PCI_RT53XX
     { PCI_DEVICE(0x1814, 0x5390) },
+    { PCI_DEVICE(0x1814, 0x539f) },
 #endif
     { 0, }
 };

cya.
Carsten

Am 06.07.2011 13:02, schrieb Helmut Schaa:
> Nice.
>
> On Wed, Jul 6, 2011 at 12:58 PM, Carsten Rietzschel <cr7@darav.de> wrote:
>> Hello together,
>>
>> attached find a small patch for the RALINK wireless driver.
>> It's just adding one PCI-ID for:
>>
>> 02:00.0 Network controller [0280]: Ralink corp. Device [1814:539f]
>>    Subsystem: Hewlett-Packard Company Device [103c:1637]
>>    Flags: bus master, fast devsel, latency 0, IRQ 17
>>    Memory at f0100000 (32-bit, non-prefetchable) [size=64K]
>>    Capabilities: [40] Power Management version 3
>>    Capabilities: [50] MSI: Enable- Count=1/32 Maskable- 64bit+
>>    Capabilities: [70] Express Endpoint, MSI 00
>>    Capabilities: [100] Advanced Error Reporting
>>    Capabilities: [140] Device Serial Number 00-00-b2-7f-05-da-f8-c0
>>    Kernel driver in use: rt2800pci
>>    Kernel modules: rt2800pci
>>
>> It's for instance used in the HP DM1Z (Fusion) Netbook.
>> I use this patch now for several weeks - starting with 2.3.29 up to
>> 3.0-rc2 kernel. No problems so far.
>>
>> *Signed*-*off*-by: Carsten Rietzschel <cr7 [at] darav [dot] de>
> That should be "Signed-off-by:". Mind to resubmit?
>
> Otherwise no objections from my side :)
> Helmut


Am 06.07.2011 13:15, schrieb Julian Calaby:
> On Wed, Jul 6, 2011 at 21:02, Helmut Schaa <helmut.schaa@googlemail.com> wrote:
>> Nice.
>>
>> On Wed, Jul 6, 2011 at 12:58 PM, Carsten Rietzschel <cr7@darav.de> wrote:
>>> Hello together,
>>>
>>> attached find a small patch for the RALINK wireless driver.
>>> It's just adding one PCI-ID for:
>>>
>>> 02:00.0 Network controller [0280]: Ralink corp. Device [1814:539f]
>>>    Subsystem: Hewlett-Packard Company Device [103c:1637]
>>>    Flags: bus master, fast devsel, latency 0, IRQ 17
>>>    Memory at f0100000 (32-bit, non-prefetchable) [size=64K]
>>>    Capabilities: [40] Power Management version 3
>>>    Capabilities: [50] MSI: Enable- Count=1/32 Maskable- 64bit+
>>>    Capabilities: [70] Express Endpoint, MSI 00
>>>    Capabilities: [100] Advanced Error Reporting
>>>    Capabilities: [140] Device Serial Number 00-00-b2-7f-05-da-f8-c0
>>>    Kernel driver in use: rt2800pci
>>>    Kernel modules: rt2800pci
>>>
>>> It's for instance used in the HP DM1Z (Fusion) Netbook.
>>> I use this patch now for several weeks - starting with 2.3.29 up to
>>> 3.0-rc2 kernel. No problems so far.
>>>
>>> *Signed*-*off*-by: Carsten Rietzschel <cr7 [at] darav [dot] de>
>> That should be "Signed-off-by:". Mind to resubmit?
> And, IIRC, you shouldn't censor your email address.
>
> Thanks,
>


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56623 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576Ab1GFLP5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2011 07:15:57 -0400
Received: by iwn6 with SMTP id 6so5982461iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jul 2011 04:15:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGXE3d-nsc3qS1pyayUqZg9AB-572FFhoB+r_ZWP9B6n=xhYHA@mail.gmail.com>
References: <4E143FCF.8030201@darav.de> <CAGXE3d-nsc3qS1pyayUqZg9AB-572FFhoB+r_ZWP9B6n=xhYHA@mail.gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 6 Jul 2011 21:15:36 +1000
Message-ID: <CAGRGNgUPOEFwpeuy4ASv8wYOa9_9ZzUGokpF-CvwNXpBZ0AS8Q@mail.gmail.com> (sfid-20110706_131600_737123_5FCE147F)
Subject: Re: RALINK rt2800pci , Patch for Device [1814:539f]
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Carsten Rietzschel <cr7@darav.de>, IvDoorn@gmail.com,
	gwingerde@gmail.com, linux-wireless@vger.kernel.org,
	users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 6, 2011 at 21:02, Helmut Schaa <helmut.schaa@googlemail.com> wrote:
> Nice.
>
> On Wed, Jul 6, 2011 at 12:58 PM, Carsten Rietzschel <cr7@darav.de> wrote:
>> Hello together,
>>
>> attached find a small patch for the RALINK wireless driver.
>> It's just adding one PCI-ID for:
>>
>> 02:00.0 Network controller [0280]: Ralink corp. Device [1814:539f]
>>    Subsystem: Hewlett-Packard Company Device [103c:1637]
>>    Flags: bus master, fast devsel, latency 0, IRQ 17
>>    Memory at f0100000 (32-bit, non-prefetchable) [size=64K]
>>    Capabilities: [40] Power Management version 3
>>    Capabilities: [50] MSI: Enable- Count=1/32 Maskable- 64bit+
>>    Capabilities: [70] Express Endpoint, MSI 00
>>    Capabilities: [100] Advanced Error Reporting
>>    Capabilities: [140] Device Serial Number 00-00-b2-7f-05-da-f8-c0
>>    Kernel driver in use: rt2800pci
>>    Kernel modules: rt2800pci
>>
>> It's for instance used in the HP DM1Z (Fusion) Netbook.
>> I use this patch now for several weeks - starting with 2.3.29 up to
>> 3.0-rc2 kernel. No problems so far.
>>
>> *Signed*-*off*-by: Carsten Rietzschel <cr7 [at] darav [dot] de>
>
> That should be "Signed-off-by:". Mind to resubmit?

And, IIRC, you shouldn't censor your email address.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/

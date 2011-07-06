Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:34433 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200Ab1GFMbZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2011 08:31:25 -0400
Received: by qwk3 with SMTP id 3so3317338qwk.19
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jul 2011 05:31:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAL1gcdNwooP+nQwtgOSqwnPcO=JozzeEyMMC7shM9nhS954E1A@mail.gmail.com>
References: <4E143FCF.8030201@darav.de>
	<CAL1gcdNwooP+nQwtgOSqwnPcO=JozzeEyMMC7shM9nhS954E1A@mail.gmail.com>
Date: Wed, 6 Jul 2011 14:31:24 +0200
Message-ID: <CAOZOX0V5nrj4KjKNaqKwJ4WsyDyX4NOpsU6_erQM7q4Yt=vehA@mail.gmail.com> (sfid-20110706_143128_431507_BDED969A)
Subject: Re: RALINK rt2800pci , Patch for Device [1814:539f]
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: Carsten Rietzschel <cr7@darav.de>, helmut.schaa@googlemail.com,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Wed, Jul 6, 2011 at 1:15 PM, Gertjan van Wingerde
<gwingerde@gmail.com> wrote:
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
> This device ID has already been added in the latest rt2x00.git tree via patch:
> http://git.kernel.org/?p=linux/kernel/git/ivd/rt2x00.git;a=commit;h=c56a574019a75c1ca36c540a8ab092a7ed35020d
>
> However, this hasn't been propagated to the wireless tree yet.
>
> Ivo, when are you planning to submit all pending patches towards the
> wireless tree?

Well actually I planned that for last weekend... :)
I'll go for the retry this evening.

Ivo

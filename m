Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f175.google.com ([209.85.223.175]:58993 "EHLO
	mail-iw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755176Ab0CDBiZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Mar 2010 20:38:25 -0500
Received: by iwn5 with SMTP id 5so1726072iwn.1
        for <linux-wireless@vger.kernel.org>; Wed, 03 Mar 2010 17:38:24 -0800 (PST)
Message-ID: <4B8F0DB6.5090209@lwfinger.net>
Date: Wed, 03 Mar 2010 19:32:38 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
CC: Michael Buesch <mb@bu3sch.de>, Nathan Schulte <reklipz@gmail.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: LP-PHY Fatal DMA error 0x00000800 on non-ULV Core 2 Duo?!?!!??!
References: <69e28c911002260708g45d3c0f7u6abf13b1babe549f@mail.gmail.com> 	<a221c0101002281538p717a3b5v16b14d251cdcc1dc@mail.gmail.com> 	<201003010122.51341.mb@bu3sch.de> <201003022257.51878.mb@bu3sch.de> 	<4B8EFF26.6040005@lwfinger.net> <69e28c911003031647o23cf5638xb0d29fb1b73aee64@mail.gmail.com>
In-Reply-To: <69e28c911003031647o23cf5638xb0d29fb1b73aee64@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/03/2010 06:47 PM, Gábor Stefanik wrote:
> On Thu, Mar 4, 2010 at 1:30 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>> On 03/02/2010 03:57 PM, Michael Buesch wrote:
>>
>>> A bug in the PCI-E core code is able to show such behavior, because all memory
>>> transfers (MMIO and DMA) from the PCI device to the wireless core are translated
>>> by the PCI-E core.
>>> I think the whole PCI-E core code has to be audited (also the specs, probably).
>>
>> I have nearly finished the update on the code section of the specs page at
>> http://bcm-v4.sipsolutions.net/PCI-E. The part that is not done involves the
>> sections that read an address from the SPROM and perform operations on that address.
>>
>> I found that the chip common registers
> 
> Do you mean the ChipCommon registers or the Backplane common registers?

Definitely, it is the chipcommon registers.

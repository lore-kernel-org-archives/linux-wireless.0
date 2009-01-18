Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f24.google.com ([209.85.218.24]:59538 "EHLO
	mail-bw0-f24.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395AbZARTRA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Jan 2009 14:17:00 -0500
Received: by bwz5 with SMTP id 5so18173bwz.17
        for <linux-wireless@vger.kernel.org>; Sun, 18 Jan 2009 11:16:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <200901181757.18648.IvDoorn@gmail.com>
References: <c6b1100b0901180730y4d32dfabn8de0024b4fc1c749@mail.gmail.com>
	 <200901181728.13706.IvDoorn@gmail.com>
	 <c6b1100b0901180850w4ab737a8la09489d7bd1ef964@mail.gmail.com>
	 <200901181757.18648.IvDoorn@gmail.com>
Date: Sun, 18 Jan 2009 19:01:15 +0000
Message-ID: <c6b1100b0901181101u5cbc0e14kb30f2a7bc8b31cf7@mail.gmail.com> (sfid-20090118_201704_700263_2A533EBD)
Subject: Re: 2.6.29-rc2 - rt61pci regression
From: Chris Clayton <chris2553@googlemail.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

2009/1/18 Ivo van Doorn <ivdoorn@gmail.com>:
> On Sunday 18 January 2009, Chris Clayton wrote:
>> 2009/1/18 Ivo van Doorn <ivdoorn@gmail.com>:
>> >> > Feel free to request any additional information needed to resolve this problem.
>> >>
>> >> Could you try below patch?
>> >>
>> >> Thanks,
>> >>
>> >> Ivo
>> >
>> > Hi,
>> >
>> > Sorry, patch won't apply correctly since rt2x00ht_create_tx_descriptor(entry, txdesc, rate); isn't
>> > in 2.6.29 yet. Below is the correct patch
>> >
>> > Ivo
>> >
>> Sorry Ivo, that neither patch applies. The second one you sent gives
>>
>> [chris:~/kernel/linux-2.6]$ patch -p1 < ~/ivo.patch
>> patching file drivers/net/wireless/rt2x00/rt2x00queue.c
>> Hunk #1 FAILED at 186.
>> Hunk #2 succeeded at 314 (offset 81 lines).
>> Hunk #3 FAILED at 408.
>> 2 out of 3 hunks FAILED -- saving rejects to file
>> drivers/net/wireless/rt2x00/rt2x00queue.c.rej
>>
>> Are you preparing patches against current wireless git? -rc2 may be a
>> bit behind that
>
> Ok, I just pulled linux-2.6.git so this should apply cleanly/
>

Yes, that patch applied and it has fixed the problem. Thanks for your help.

Chris
-- 
In a world without walls and fences, who needs windows and gates?

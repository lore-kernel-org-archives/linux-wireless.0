Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f20.google.com ([209.85.219.20]:40628 "EHLO
	mail-ew0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614AbZARTMP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Jan 2009 14:12:15 -0500
Received: by ewy13 with SMTP id 13so37339ewy.13
        for <linux-wireless@vger.kernel.org>; Sun, 18 Jan 2009 11:12:13 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Chris Clayton <chris2553@googlemail.com>
Subject: Re: 2.6.29-rc2 - rt61pci regression
Date: Sun, 18 Jan 2009 20:12:10 +0100
Cc: linux-wireless@vger.kernel.org
References: <c6b1100b0901180730y4d32dfabn8de0024b4fc1c749@mail.gmail.com> <200901181757.18648.IvDoorn@gmail.com> <c6b1100b0901181101u5cbc0e14kb30f2a7bc8b31cf7@mail.gmail.com>
In-Reply-To: <c6b1100b0901181101u5cbc0e14kb30f2a7bc8b31cf7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200901182012.10829.IvDoorn@gmail.com> (sfid-20090118_201220_383205_9251BC02)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 18 January 2009, Chris Clayton wrote:
> Hi,
> 
> 2009/1/18 Ivo van Doorn <ivdoorn@gmail.com>:
> > On Sunday 18 January 2009, Chris Clayton wrote:
> >> 2009/1/18 Ivo van Doorn <ivdoorn@gmail.com>:
> >> >> > Feel free to request any additional information needed to resolve this problem.
> >> >>
> >> >> Could you try below patch?
> >> >>
> >> >> Thanks,
> >> >>
> >> >> Ivo
> >> >
> >> > Hi,
> >> >
> >> > Sorry, patch won't apply correctly since rt2x00ht_create_tx_descriptor(entry, txdesc, rate); isn't
> >> > in 2.6.29 yet. Below is the correct patch
> >> >
> >> > Ivo
> >> >
> >> Sorry Ivo, that neither patch applies. The second one you sent gives
> >>
> >> [chris:~/kernel/linux-2.6]$ patch -p1 < ~/ivo.patch
> >> patching file drivers/net/wireless/rt2x00/rt2x00queue.c
> >> Hunk #1 FAILED at 186.
> >> Hunk #2 succeeded at 314 (offset 81 lines).
> >> Hunk #3 FAILED at 408.
> >> 2 out of 3 hunks FAILED -- saving rejects to file
> >> drivers/net/wireless/rt2x00/rt2x00queue.c.rej
> >>
> >> Are you preparing patches against current wireless git? -rc2 may be a
> >> bit behind that
> >
> > Ok, I just pulled linux-2.6.git so this should apply cleanly/
> >
> 
> Yes, that patch applied and it has fixed the problem. Thanks for your help.

Excellent, I'll send John to wireless-testing version of the patch. :)

Ivo

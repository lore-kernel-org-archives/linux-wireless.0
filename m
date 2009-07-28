Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f221.google.com ([209.85.218.221]:59077 "EHLO
	mail-bw0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbZG1OPE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jul 2009 10:15:04 -0400
Received: by bwz21 with SMTP id 21so53138bwz.37
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2009 07:15:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <efe7343f0907280638i12b0bb4bq237ca4f6376eb1fe@mail.gmail.com>
References: <c6b1100b0907130127g3d4013c6n3264f79bd74bc9@mail.gmail.com>
	 <200907272035.41193.chris2553@googlemail.com>
	 <1248725279.7440.8.camel@mj>
	 <200907272122.11290.chris2553@googlemail.com>
	 <1248726744.32365.4.camel@johannes.local>
	 <c6b1100b0907280403x697d8816mfb5206e1fb93243a@mail.gmail.com>
	 <efe7343f0907280411y61e8a68dj500c2a74ad1af28a@mail.gmail.com>
	 <c6b1100b0907280634j4610d077rb30f1f571aac7f36@mail.gmail.com>
	 <efe7343f0907280638i12b0bb4bq237ca4f6376eb1fe@mail.gmail.com>
Date: Tue, 28 Jul 2009 15:15:03 +0100
Message-ID: <c6b1100b0907280715y308591c8xfa86239326f92fbe@mail.gmail.com>
Subject: Re: 2.6.31-rc2: Possible regression in rt61pci driver
From: Chris Clayton <chris2553@googlemail.com>
To: Luis Correia <luis.f.correia@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org,
	Ivo van Doorn <ivdoorn@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis,

2009/7/28 Luis Correia <luis.f.correia@gmail.com>:
> Chris
>
> On Tue, Jul 28, 2009 at 14:34, Chris Clayton<chris2553@googlemail.com> wrote:
>> 2009/7/28 Luis Correia <luis.f.correia@gmail.com>:
>>> Hi Chris
>>
>>> Can you do a very dumb test for me?
>>>
>>> Boot your laptop by adding 'irqpoll' to the kernel command line
>>> options and see if the problem still occours.
>>>
>>
>> Not so dumb a request, actually.  Running -rc4 with the irqpoll
>> command line option, the laptop has just survived 30 minutes without a
>> freeze. It can't survive more than 5 minutes without that option.
>>
>> Chris
>
> Well, if the laptop hangs on working without any problems, this may
> proove to be some strange kind of hardware incompatibility.
>
> The irqpoll option solves some of the interrupt related problems, by
> polling them instead of 'grabbing' them (at least that is what I think
> it is happening, correct me if I'm wrong:))
>

I've no idea whether you are right or wrong :-) If it is a hardware
quirk, the odd thing is that the card has worked perfectly (modulo
development cycle bugs that I've unearthed and reported) for a long
time now, including the codemonkey driver before rt2x00 hit mainline.

Anyway, thanks for your help.

Chris

>
> Luis Correia
> rt2x00 project admin
>



-- 
No, Sir; there is nothing which has yet been contrived by man, by which
so much happiness is produced as by a good tavern or inn - Doctor Samuel
Johnson

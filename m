Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f177.google.com ([209.85.211.177]:41033 "EHLO
	mail-yw0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932261AbZHCPGR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2009 11:06:17 -0400
Received: by ywh7 with SMTP id 7so4050259ywh.21
        for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2009 08:06:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <efe7343f0908020237k61fa7656s458cee0217b46c69@mail.gmail.com>
References: <efe7343f0908020214m6d8b2518n51d4264943ce273a@mail.gmail.com>
	<1249204732.2007.49.camel@johannes.local> <efe7343f0908020226n4b693defv38546a6f8aa1cfd9@mail.gmail.com>
	<1249205597.2007.50.camel@johannes.local> <efe7343f0908020237k61fa7656s458cee0217b46c69@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 3 Aug 2009 08:05:57 -0700
Message-ID: <43e72e890908030805l57399345w668ccd2cacbb8198@mail.gmail.com>
Subject: Re: Unsupported PHY on B43
To: Luis Correia <luis.f.correia@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Aug 2, 2009 at 2:37 AM, Luis Correia<luis.f.correia@gmail.com> wrote:
> On Sun, Aug 2, 2009 at 10:33, Johannes Berg<johannes@sipsolutions.net> wrote:
>> On Sun, 2009-08-02 at 10:26 +0100, Luis Correia wrote:
>>
>>> > This is an 11n phy.
>>>
>>> Great, an 11n device with only two antennas (they are usually three).
>>
>> Oh, it depends on the configuration -- maybe they used a cheaper device
>> with fewer chains.
>
> yes, it even is a half-height minipci-express card, the first one I've
> seen so far.

11n does not require three antennas. It really depends on the number
of streams you have and the chain configuration. As a matter of fact
you can use 11n with 1 stream and only use the lower MCS rates.

>>> >> I'm available to test drivers, patches, git kernels, the whole lot.
>>> >
>>> > There's nothing available beyond what you have.
>>>
>>> Bummer, I guess I'll have to wait then.
>>
>> Don't hold your breath -- nobody's working on it. I also really want it
>> working, but since nobody seems even interested in writing the driver,
>> we've halted the reverse engineering effort.
>
> 11n is doomed on Linux :(

No its not.

  Luis

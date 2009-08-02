Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:62761 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569AbZHBJht (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Aug 2009 05:37:49 -0400
Received: by ey-out-2122.google.com with SMTP id 9so790065eyd.37
        for <linux-wireless@vger.kernel.org>; Sun, 02 Aug 2009 02:37:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1249205597.2007.50.camel@johannes.local>
References: <efe7343f0908020214m6d8b2518n51d4264943ce273a@mail.gmail.com>
	 <1249204732.2007.49.camel@johannes.local>
	 <efe7343f0908020226n4b693defv38546a6f8aa1cfd9@mail.gmail.com>
	 <1249205597.2007.50.camel@johannes.local>
Date: Sun, 2 Aug 2009 10:37:48 +0100
Message-ID: <efe7343f0908020237k61fa7656s458cee0217b46c69@mail.gmail.com>
Subject: Re: Unsupported PHY on B43
From: Luis Correia <luis.f.correia@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Aug 2, 2009 at 10:33, Johannes Berg<johannes@sipsolutions.net> wrote:
> On Sun, 2009-08-02 at 10:26 +0100, Luis Correia wrote:
>
>> > This is an 11n phy.
>>
>> Great, an 11n device with only two antennas (they are usually three).
>
> Oh, it depends on the configuration -- maybe they used a cheaper device
> with fewer chains.

yes, it even is a half-height minipci-express card, the first one I've
seen so far.

>> >> I'm available to test drivers, patches, git kernels, the whole lot.
>> >
>> > There's nothing available beyond what you have.
>>
>> Bummer, I guess I'll have to wait then.
>
> Don't hold your breath -- nobody's working on it. I also really want it
> working, but since nobody seems even interested in writing the driver,
> we've halted the reverse engineering effort.

11n is doomed on Linux :(

>
> johannes
>

Luis Correia

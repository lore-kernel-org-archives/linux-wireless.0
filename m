Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f54.google.com ([209.85.214.54]:52257 "EHLO
        mail-it0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752986AbeDLRFg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Apr 2018 13:05:36 -0400
Received: by mail-it0-f54.google.com with SMTP id f6-v6so8254795ita.2
        for <linux-wireless@vger.kernel.org>; Thu, 12 Apr 2018 10:05:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1517ecac1d85eb746367d9db436beca2d8f47835.camel@redhat.com>
References: <CAE4vF2fCTEmEX8i+XVpvTJ1sRYDHDLr+fYFAM2PzTQTqkCoXVQ@mail.gmail.com>
 <CAE4vF2f2oXEvOJWDXPjmiWZTC=HOq5+xE_R64-_VvH6zc-Vw+A@mail.gmail.com>
 <5ACF0F5A.3090301@broadcom.com> <CAE4vF2ftgMPhKEUHr2rPaobM9Dtuc-B9rtbF5tWavvrwUXA7Ag@mail.gmail.com>
 <5ACF3A28.4060303@broadcom.com> <CALLGbRLJLxu92S2bYFOk9oJCLanES4Fu6e-9bh9oAupEC0Uw5w@mail.gmail.com>
 <1517ecac1d85eb746367d9db436beca2d8f47835.camel@redhat.com>
From: "solsTiCe d'Hiver" <solstice.dhiver@gmail.com>
Date: Thu, 12 Apr 2018 19:05:35 +0200
Message-ID: <CAE4vF2fvumVELT5rScptjVC4JOqw5cqEu7yLrYZ64ci=5R6ZRQ@mail.gmail.com> (sfid-20180412_190540_583803_D042CFAF)
Subject: Re: second wifi card enforce CN reg dom
To: Dan Williams <dcbw@redhat.com>
Cc: Steve deRosier <derosier@gmail.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi.

I thought I made myself clear.
I leave in France. My system(s) is/are set up to use FR as default
regulatory domain.

But when I plug in that tp-link card, I am restricted to use CN
regulatory domain. Why am I the only one to see this as a problem ?

I know that one can only have one regdom defined on the system. I have
set it up myself. So why is it changed behind my back by some card or
whatever ?
Like I said, I am left with the option, to disable crda, or to use 2
systems, one for each card !

Or may be try Windows when this is not messed up like that ??? Well,
it's not on Windows that I will be able to use monitor mode, anyway.

Never mind.

2018-04-12 17:52 GMT+02:00 Dan Williams <dcbw@redhat.com>:
> On Thu, 2018-04-12 at 08:18 -0700, Steve deRosier wrote:
>> On Thu, Apr 12, 2018 at 3:51 AM, Arend van Spriel
>> <arend.vanspriel@broadcom.com> wrote:
>> > On 4/12/2018 10:42 AM, solsTiCe d'Hiver wrote:
>> > >
>> > > Hi.
>> > >
>> > > This is beyond my comprehension that you could assert this is a
>> > > non issue.
>> >
>> >
>> > Well. I am just saying that it is by design. There is no way for
>> > the
>> > regulatory code to determine where you and your hardware actually
>> > reside so
>> > instead it takes a conservative approach.
>> >
>>
>> To say it another way: mixing regulatory domains on your host system
>> should result in a _smaller_ set of channels - ie only those channels
>> at the intersection of the two.
>>
>> And another wrinkle to consider - one of the 802.11 amendments (can't
>> remember which one) actually causes the radio to listen to the
>
> 802.11d I believe, from the early 2000s.
>
> Dan
>
>> beacons
>> around it, determine what the local regulatory domain is based on the
>> beacons it hears, and then lock to that regulatory domain. It's
>> possible for that information to be propagated up to the card's host
>> and the regulatory domain then would affect both cards. That's how
>> it's supposed to work, though I don't factually know Linux does this
>> in all cases.  Could it be you're somewhere where CN is the local
>> regulatory domain and the TL-WN722N has this feature?
>>
>> In any case, as Arend points out, despite the hand-wringing that
>> regulatory domains cause users trying to do something particular,
>> between certain rules and regulations and certain manufacturers bad
>> interpretations and implementations around it, there's little that
>> can
>> be done about it. Fact is, your radio must comply to whatever
>> regulatory domain you are in, otherwise it's breaking the rules. And
>> people breaking the regulatory rules is part of what's gotten
>> governments to pass even worse (for us OSS guys) laws that tighten
>> those rules down further.
>>
>> You asked who to contact. Its not the LKML - it's your relevant
>> government body. And certain manufacturers who improperly interpret
>> said rules because it's easier for them.
>>
>> - Steve
>>
>> --
>> Steve deRosier
>> Cal-Sierra Consulting LLC
>> https://www.cal-sierra.com/

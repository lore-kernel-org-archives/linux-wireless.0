Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52738 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751106AbeF2G6y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Jun 2018 02:58:54 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/6] brcmfmac: fix 160MHz support and monitor mode
References: <1529693004-20569-1-git-send-email-arend.vanspriel@broadcom.com>
        <CACna6rwzS-KXZ80wudpNEcrtnPd7fUWYKbT93hfFMfQi-V-hhg@mail.gmail.com>
        <CACna6rzpUDWBR_SXciEo8Z3Fsa6VZT0-KL2=WCzz9v8ww6tZVA@mail.gmail.com>
        <5B30A85C.5080105@broadcom.com>
        <CACna6rwGrcJ6iEv6+Bh+qC0T-yGfjvs8AweQ-4gM5JcO+JC0Dg@mail.gmail.com>
Date: Fri, 29 Jun 2018 09:58:49 +0300
In-Reply-To: <CACna6rwGrcJ6iEv6+Bh+qC0T-yGfjvs8AweQ-4gM5JcO+JC0Dg@mail.gmail.com>
        (=?utf-8?Q?=22Rafa=C5=82_Mi=C5=82ecki=22's?= message of "Mon, 25 Jun 2018
 10:43:55 +0200")
Message-ID: <871scqgjti.fsf@codeaurora.org> (sfid-20180629_085857_793823_7CAF65B7)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> writes:

> On Mon, 25 Jun 2018 at 10:31, Arend van Spriel
> <arend.vanspriel@broadcom.com> wrote:
>>
>> On 6/25/2018 6:40 AM, Rafa=C5=82 Mi=C5=82ecki wrote:
>> > On Sun, 24 Jun 2018 at 13:48, Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.co=
m> wrote:
>> >> On Fri, 22 Jun 2018 at 20:45, Arend van Spriel
>> >> <arend.vanspriel@broadcom.com> wrote:
>> >>> Here a couple of patches in preparation of monitor mode support. It
>> >>> is mostly about querying firmware for support. While at it I stumbled
>> >>> upon the fact that 160MHz was not completely implemented in the driv=
er
>> >>> so there is a patch for that as well.
>> >>>
>> >>> The first two patches are actually some changes to the patches that
>> >>> Rafal submitted. So this series depend on:
>> >>>
>> >>> [V3,2/2] brcmfmac: handle monitor mode marked msgbuf packets [1]
>> >>>
>> >>> These apply to the master branch of the wireless-drivers-next reposi=
tory.
>> >>>
>> >>> [1] https://patchwork.kernel.org/patch/10474799/
>> >>
>> >> I find it pointless to submit fixes for patches that weren't accepted
>> >> yet. Let's work on improving original patches while they are still
>> >> pending.
>> >
>> > I sent V4 with changes pointed our by Arend. That obsoletes all (?)
>> > monitor patches from this patchset. I believe it was cleaner to
>> > improve original patchset (not pushed yet).
>> >
>> > My suggestion is to apply patches 3/6 and 4/6 (they aren't monitor
>> > related) and drop the others.
>>
>> Well. Given that Kalle prefers applying "all-or-nothing" I will resubmit
>> the series addressing the issues you found.
>
> I wasn't aware of this, good to know, thanks!

Yes, "all-or-nothing" method is both fastest and less error prone,
that's why I prefer that. I got a bit lost with your discussion so
please check carefully that I haven't dropped anything wrong.

--=20
Kalle Valo

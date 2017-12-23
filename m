Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f53.google.com ([74.125.83.53]:37983 "EHLO
        mail-pg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750713AbdLWLOw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 23 Dec 2017 06:14:52 -0500
Received: by mail-pg0-f53.google.com with SMTP id f12so15427075pgo.5
        for <linux-wireless@vger.kernel.org>; Sat, 23 Dec 2017 03:14:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1712230819270.14868@Nettop>
References: <alpine.LNX.2.21.99.1712201832120.21664@localhost.localdomain>
 <20171221142026.GA4655@redhat.com> <alpine.LNX.2.00.1712230819270.14868@Nettop>
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Date: Sat, 23 Dec 2017 12:14:50 +0100
Message-ID: <CAA2SeNKzgn_xkJvc5PZ3V=Oey2xpCo7DenptD_8vtMt=BL5VnQ@mail.gmail.com> (sfid-20171223_121456_553337_A8469958)
Subject: Re: MT7630 support
To: Hans Ulli Kroll <ulli.kroll@googlemail.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        Enrico Mioso <mrkiko.rs@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Arnd Bergmann <arnd@arndb.de>, John Crispin <john@phrozen.org>,
        Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Hi
>
> On Thu, 21 Dec 2017, Stanislaw Gruszka wrote:
>
>> On Wed, Dec 20, 2017 at 06:39:34PM +0100, Enrico Mioso wrote:
>> > Hello guys.
>> > So, at some point I felt crazy enough to try to add support for the MT7630 chipset to the rt2xx ralink wireless drivers.
>> > I expected this to be a little bit of a challenge.
>> > I did begin adding some code paths around, reading from the mixed-up drivers here:
>> > https://github.com/neurobin/MT7630E
>> > (thanks a lot to the guys who are working on this, and who worked on this).
>> > and working on the kernel's git rt2xx tree. I am sending a raw diff that will for sure not compile. I am asking for guidance and help in going on.
>>
>> I think better way to add support for MT7630 chip to mailine kernel
>> would be via new Felix's mt76 driver, because there are less diffrence
>> between MT7630 and MT76x2 than between MT7630 and the old Ralink chips.
>>
>
> MT7630e is part of the MT76x0 family
> Felix's driver is missing the baseband/rf tables for MT76x0.
>
> The full driver for MT7610E is here
> https://github.com/i80s/mtk-sources
>
> /me now reading Felix code to adapot MT76x2 for mt7612u ...

Hi Hans,

very good news since that task is in my TODO list for a while now so I
guess we can start working together on it.
Have you already had some working code to support mt7612u on mt76 or
just looking at the code?

Regards,
Lorenzo

>
> Greetings
> Ulli



-- 
UNIX is Sexy: who | grep -i blonde | talk; cd ~; wine; talk; touch;
unzip; touch; strip; gasp; finger; gasp; mount; fsck; more; yes; gasp;
umount; make clean; sleep

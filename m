Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f182.google.com ([209.85.128.182]:41298 "EHLO
        mail-wr0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750752AbdLWHj2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 23 Dec 2017 02:39:28 -0500
Received: by mail-wr0-f182.google.com with SMTP id p69so20768591wrb.8
        for <linux-wireless@vger.kernel.org>; Fri, 22 Dec 2017 23:39:27 -0800 (PST)
Date: Sat, 23 Dec 2017 08:39:24 +0100 (CET)
From: Enrico Mioso <mrkiko.rs@gmail.com>
To: Hans Ulli Kroll <ulli.kroll@googlemail.com>
cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Arnd Bergmann <arnd@arndb.de>, John Crispin <john@phrozen.org>,
        nbd@nbd.name
Subject: Re: MT7630 support
In-Reply-To: <alpine.LNX.2.00.1712230819270.14868@Nettop>
Message-ID: <alpine.LNX.2.21.99.1712230838330.18168@localhost.localdomain> (sfid-20171223_083933_047031_7F2E1375)
References: <alpine.LNX.2.21.99.1712201832120.21664@localhost.localdomain> <20171221142026.GA4655@redhat.com> <alpine.LNX.2.00.1712230819270.14868@Nettop>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Ulli!

First of all - thank you for the help and the precious info / link.
I'll look at it now.
Thank you very very much.

Enrico


On Sat, 23 Dec 2017, Hans Ulli Kroll wrote:

> Date: Sat, 23 Dec 2017 08:28:22
> From: Hans Ulli Kroll <ulli.kroll@googlemail.com>
> To: Stanislaw Gruszka <sgruszka@redhat.com>
> Cc: Enrico Mioso <mrkiko.rs@gmail.com>, linux-wireless@vger.kernel.org,
>     Johannes Berg <johannes.berg@intel.com>,
>     Daniel Golle <daniel@makrotopia.org>, Arnd Bergmann <arnd@arndb.de>,
>     John Crispin <john@phrozen.org>, nbd@nbd.name
> Subject: Re: MT7630 support
> 
> Hi
>
> On Thu, 21 Dec 2017, Stanislaw Gruszka wrote:
>
>> On Wed, Dec 20, 2017 at 06:39:34PM +0100, Enrico Mioso wrote:
>>> Hello guys.
>>> So, at some point I felt crazy enough to try to add support for the MT7630 chipset to the rt2xx ralink wireless drivers.
>>> I expected this to be a little bit of a challenge.
>>> I did begin adding some code paths around, reading from the mixed-up drivers here:
>>> https://github.com/neurobin/MT7630E
>>> (thanks a lot to the guys who are working on this, and who worked on this).
>>> and working on the kernel's git rt2xx tree. I am sending a raw diff that will for sure not compile. I am asking for guidance and help in going on.
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
>
> Greetings
> Ulli
>

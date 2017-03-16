Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60394 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751130AbdCPHuS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Mar 2017 03:50:18 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        linux-wireless@vger.kernel.org, btherthala@quantenna.com,
        hwang@quantenna.com, smaksimenko@quantenna.com,
        dlebed@quantenna.com,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        Kamlesh Rath <krath@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Subject: Re: [PATCH v4] qtnfmac: announcement of new FullMAC driver for Quantenna chipsets
References: <1483952830-3967-1-git-send-email-igor.mitsyanko.os@quantenna.com>
        <af3dbd89-d9e8-7f6a-d48a-ebe430671963@gmail.com>
        <87d1dt6w9m.fsf@purkki.adurom.net>
        <ca350f9b-55de-8903-b213-c041f8b569e3@broadcom.com>
        <6be6c73d-381b-6579-8b57-2a836973b446@quantenna.com>
        <1489500220.10872.8.camel@sipsolutions.net>
Date: Thu, 16 Mar 2017 09:50:11 +0200
In-Reply-To: <1489500220.10872.8.camel@sipsolutions.net> (Johannes Berg's
        message of "Tue, 14 Mar 2017 15:03:40 +0100")
Message-ID: <87h92twtho.fsf@kamboji.qca.qualcomm.com> (sfid-20170316_085021_910214_636A6284)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

>> 1. Modify cfg80211 driver patch to introduce ability to boot from
>> card's internal flash rather then over PCIe only. This will hopefully
>> unblock=C2=A0 driver itself.
>
> This is good, and I think that'll be OK for the driver.

I'm thinking the same.

>> 2. Work internally to provide access to SDK used to build firmware on
>> a public server, that has to be accessible for two years. Then submit
>> firmware to linux-firmware again.
>
> I'm not sure this will work, since it would fall on anyone
> redistributing to ensure it's still there after *they* distribute it,
> so anyone who has the linux-firmware repo... That's why it's most
> practical to simply combine the two, although that's not really the
> case here.

How can we find a solution to this? We already one another driver with a
similar problem with sources and I guess more to come. Should we bring
this up in TAB?

https://www.linuxfoundation.org/projects/linux/tab

--=20
Kalle Valo

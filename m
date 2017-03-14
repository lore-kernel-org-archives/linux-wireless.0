Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39648 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751635AbdCNODo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Mar 2017 10:03:44 -0400
Message-ID: <1489500220.10872.8.camel@sipsolutions.net> (sfid-20170314_150447_016814_3C7715E8)
Subject: Re: [PATCH v4] qtnfmac: announcement of new FullMAC driver for
 Quantenna chipsets
From: Johannes Berg <johannes@sipsolutions.net>
To: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org, btherthala@quantenna.com,
        hwang@quantenna.com, smaksimenko@quantenna.com,
        dlebed@quantenna.com,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        Kamlesh Rath <krath@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Date: Tue, 14 Mar 2017 15:03:40 +0100
In-Reply-To: <6be6c73d-381b-6579-8b57-2a836973b446@quantenna.com>
References: <1483952830-3967-1-git-send-email-igor.mitsyanko.os@quantenna.com>
         <af3dbd89-d9e8-7f6a-d48a-ebe430671963@gmail.com>
         <87d1dt6w9m.fsf@purkki.adurom.net>
         <ca350f9b-55de-8903-b213-c041f8b569e3@broadcom.com>
         <6be6c73d-381b-6579-8b57-2a836973b446@quantenna.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> 1. Modify cfg80211 driver patch to introduce ability to boot from
> card's 
> internal flash rather then over PCIe only. This will hopefully
> unblock 
> driver itself.

This is good, and I think that'll be OK for the driver.

> 2. Work internally to provide access to SDK used to build firmware on
> a 
> public server, that has to be accessible for two years. Then submit 
> firmware to linux-firmware again.

I'm not sure this will work, since it would fall on anyone
redistributing to ensure it's still there after *they* distribute it,
so anyone who has the linux-firmware repo... That's why it's most
practical to simply combine the two, although that's not really the
case here.

johannes

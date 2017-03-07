Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51992 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752390AbdCGNtw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Mar 2017 08:49:52 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: igor.mitsyanko.os@quantenna.com, linux-wireless@vger.kernel.org,
        johannes@sipsolutions.net, btherthala@quantenna.com,
        hwang@quantenna.com, smaksimenko@quantenna.com,
        dlebed@quantenna.com,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        Kamlesh Rath <krath@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Subject: Re: [PATCH v4] qtnfmac: announcement of new FullMAC driver for Quantenna chipsets
References: <1483952830-3967-1-git-send-email-igor.mitsyanko.os@quantenna.com>
        <af3dbd89-d9e8-7f6a-d48a-ebe430671963@gmail.com>
Date: Tue, 07 Mar 2017 15:39:49 +0200
In-Reply-To: <af3dbd89-d9e8-7f6a-d48a-ebe430671963@gmail.com>
 (=?utf-8?Q?=22Rafa=C5=82=09Mi=C5=82ecki=22's?= message of "Mon, 6 Mar 2017
 22:19:18 +0100")
Message-ID: <87d1dt6w9m.fsf@purkki.adurom.net> (sfid-20170307_145001_999819_0995015F)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> writes:

> On 01/09/2017 10:07 AM, igor.mitsyanko.os@quantenna.com wrote:
>> From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
>>
>> This patch adds support for new FullMAC WiFi driver for Quantenna
>> QSR10G chipsets.
>>
>> QSR10G (aka Pearl) is Quantenna's 8x8, 160M, 11ac offering.
>> QSR10G supports 2 simultaneous WMACs - one 5G and one 2G.
>> 5G WMAC supports 160M, 8x8 configuration. FW supports
>> up to 8 concurrent virtual interfaces on each WMAC.
>>
>> Patch introduces 2 new drivers:
>> - qtnfmac.ko for interfacing with kernel wireless core
>> - qtnfmac_pearl_pcie.ko for interfacing with hardware over PCIe interface
>
> Hi, what's the state of this patch?

I haven't had a chance to look at the latest review comments yet, but
this is starting to look good, I think.

> Kalle I see it in your pending branch, could you give me/us a hint
> what does it mean, please?

The pending branch usually contains patches which I want the kbuild bot
to test.

--=20
Kalle Valo

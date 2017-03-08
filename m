Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f173.google.com ([209.85.220.173]:35163 "EHLO
        mail-qk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750710AbdCHJTE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Mar 2017 04:19:04 -0500
Received: by mail-qk0-f173.google.com with SMTP id v125so53660288qkh.2
        for <linux-wireless@vger.kernel.org>; Wed, 08 Mar 2017 01:18:00 -0800 (PST)
Subject: Re: [PATCH v4] qtnfmac: announcement of new FullMAC driver for
 Quantenna chipsets
To: Kalle Valo <kvalo@codeaurora.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
References: <1483952830-3967-1-git-send-email-igor.mitsyanko.os@quantenna.com>
 <af3dbd89-d9e8-7f6a-d48a-ebe430671963@gmail.com>
 <87d1dt6w9m.fsf@purkki.adurom.net>
Cc: igor.mitsyanko.os@quantenna.com, linux-wireless@vger.kernel.org,
        johannes@sipsolutions.net, btherthala@quantenna.com,
        hwang@quantenna.com, smaksimenko@quantenna.com,
        dlebed@quantenna.com,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        Kamlesh Rath <krath@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <ca350f9b-55de-8903-b213-c041f8b569e3@broadcom.com> (sfid-20170308_101914_836361_89FC465D)
Date: Wed, 8 Mar 2017 10:10:42 +0100
MIME-Version: 1.0
In-Reply-To: <87d1dt6w9m.fsf@purkki.adurom.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7-3-2017 14:39, Kalle Valo wrote:
> Rafał Miłecki <zajec5@gmail.com> writes:
> 
>> On 01/09/2017 10:07 AM, igor.mitsyanko.os@quantenna.com wrote:
>>> From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
>>>
>>> This patch adds support for new FullMAC WiFi driver for Quantenna
>>> QSR10G chipsets.
>>>
>>> QSR10G (aka Pearl) is Quantenna's 8x8, 160M, 11ac offering.
>>> QSR10G supports 2 simultaneous WMACs - one 5G and one 2G.
>>> 5G WMAC supports 160M, 8x8 configuration. FW supports
>>> up to 8 concurrent virtual interfaces on each WMAC.
>>>
>>> Patch introduces 2 new drivers:
>>> - qtnfmac.ko for interfacing with kernel wireless core
>>> - qtnfmac_pearl_pcie.ko for interfacing with hardware over PCIe interface
>>
>> Hi, what's the state of this patch?
> 
> I haven't had a chance to look at the latest review comments yet, but
> this is starting to look good, I think.

So what is the status for the firmware patch. It was submitted as RFC a
while ago [1].

Regards,
Arend

[1] https://patchwork.kernel.org/patch/9487515/

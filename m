Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bn3nam01on0078.outbound.protection.outlook.com ([104.47.33.78]:44620
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750778AbdEIWXc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 May 2017 18:23:32 -0400
Subject: Re: [PATCH v5] qtnfmac: announcement of new FullMAC driver for
 Quantenna chipsets
To: Kalle Valo <kvalo@codeaurora.org>
CC: <linux-wireless@vger.kernel.org>, <johannes@sipsolutions.net>,
        Dmitrii Lebed <dlebed@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        Bindu Therthala <btherthala@quantenna.com>,
        Huizhao Wang <hwang@quantenna.com>,
        Kamlesh Rath <krath@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
References: <1489262657-8191-1-git-send-email-igor.mitsyanko.os@quantenna.com>
 <c80e4171-d433-6f31-f279-94aa5d238dc7@quantenna.com>
 <878tm69imk.fsf@purkki.adurom.net> <874lwu9igt.fsf@purkki.adurom.net>
From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Message-ID: <6e93ccf6-d55a-0b74-0747-a3c371b4bec0@quantenna.com> (sfid-20170510_002337_804215_269A71A7)
Date: Tue, 9 May 2017 15:23:24 -0700
MIME-Version: 1.0
In-Reply-To: <874lwu9igt.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 05/09/2017 08:07 AM, Kalle Valo wrote:
> 
> External Email
> 
> 
> Kalle Valo <kvalo@codeaurora.org> writes:
> 
>>>> QSR10G (aka Pearl) is Quantenna's 8x8, 160M, 11ac offering.
>>>> QSR10G supports 2 simultaneous WMACs - one 5G and one 2G.
>>>> 5G WMAC supports 160M, 8x8 configuration. FW supports
>>>> up to 8 concurrent virtual interfaces on each WMAC.
>>>>
>>>> Patch introduces 2 new drivers:
>>>> - qtnfmac.ko for interfacing with kernel wireless core
>>>> - qtnfmac_pearl_pcie.ko for interfacing with hardware over PCIe interface
>>
>> Please mention in the commit log also what modes (AP, managed, monitor
>> etc) are supported.
> 
> Oh, and drop the word "announcement" from the title. Something like
> "qtnfmac: add new FullMAC driver for Quantenna chipsets" is good enough.

OK,
thanks Kalle.

> 
> --
> Kalle Valo
> 

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bn3nam01on0084.outbound.protection.outlook.com ([104.47.33.84]:45568
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752081AbdH3SUP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Aug 2017 14:20:15 -0400
Subject: Re: [PATCH 00/27] qtnfmac: allow to configure channel, BW, HT/VHT
 caps
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        sergey.matyukevich.os@quantenna.com, avinashp@quantenna.com,
        johannes@sipsolutions.net
References: <20170825023024.10565-1-igor.mitsyanko.os@quantenna.com>
 <87ziahni8p.fsf@purkki.adurom.net>
From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Message-ID: <fb84ce29-08fc-ffc4-8974-b9cb95a5b93a@quantenna.com> (sfid-20170830_202050_668774_45B593F6)
Date: Wed, 30 Aug 2017 11:20:07 -0700
MIME-Version: 1.0
In-Reply-To: <87ziahni8p.fsf@purkki.adurom.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/30/2017 09:16 AM, Kalle Valo wrote:
> 
> igor.mitsyanko.os@quantenna.com writes:
> 
>> This patchset has a goal to make operational parameters (channel, BW,
>> HT/VHT capabilities) configuration possible for qtnfmac driver.
>> Basically the idea is to make driver level as thin as possible, and let
>> everything to be handled by userspace/nl80211 and wireless device itself.
> 
> This patchset is just too big and pain to review. Preferably no more
> than 10-12 patches per set, please. If the patches bigger then the limit
> should be even lower.

Sure, will split in 3 patchsets then.

> 
> --
> Kalle Valo
> 

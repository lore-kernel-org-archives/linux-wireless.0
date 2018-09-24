Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [12.131.200.82] ([12.131.200.82]:42714 "EHLO
        fm-smtp01.quantenna.com" rhost-flags-FAIL-FAIL-OK-OK)
        by vger.kernel.org with ESMTP id S1726417AbeIXOeD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Sep 2018 10:34:03 -0400
Subject: Re: [PATCH 01/11] qtnfmac_pcie: do not store FW name in driver state
 structure
To: Kalle Valo <kvalo@codeaurora.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Sergey Matyukevich OS <sergey.matyukevich.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>
References: <20180924051246.13371-1-igor.mitsyanko.os@quantenna.com>
 <20180924051246.13371-2-igor.mitsyanko.os@quantenna.com>
 <87va6vqrg3.fsf@purkki.adurom.net>
From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Message-ID: <f6dd6a7c-4823-a10b-6c02-76a081262abd@quantenna.com> (sfid-20180924_103310_167528_3F2F035E)
Date: Mon, 24 Sep 2018 01:21:14 -0700
MIME-Version: 1.0
In-Reply-To: <87va6vqrg3.fsf@purkki.adurom.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/24/2018 12:34 AM, Kalle Valo wrote:
> 
> 
> Igor Mitsyanko SO <igor.mitsyanko.os@quantenna.com> writes:
> 
>> Firmware name is only needed at probe stage, no point in keeping it in
>> driver state structure.
>>
>> Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
> 
> This is just cosmetics, but what's that "SO" in the From field? Do note
> that if I apply these patches as is that will be stored also to git.


Looks like something new from my mail system.. Will get rid of that and 
resend the series. Thanks!

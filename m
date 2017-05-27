Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:43414 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750750AbdE0Vic (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 27 May 2017 17:38:32 -0400
Subject: Re: [PATCH] Per chain RSSI reporting
To: Norik Dzhandzhapanyan <norikd@ethertronics.com>,
        Adrian Chadd <adrian@freebsd.org>
References: <SN1PR08MB1373BF583E9CE2AA6A0F6381B0FC0@SN1PR08MB1373.namprd08.prod.outlook.com>
 <CAJ-VmomiKOgV4pJWNKdOCzsUJZYEixvP4p5bQ9X1FBqAGk_o0w@mail.gmail.com>
 <SN1PR08MB137316C4132262145C58CEA3B0FD0@SN1PR08MB1373.namprd08.prod.outlook.com>
 <21095854-07c7-7586-6a6e-e60c11932b84@candelatech.com>
 <CAJ-Vmonp72WpT_aUVo_To+k676Ra8S165efPOyXRvvk=_W0YEQ@mail.gmail.com>
 <8e314337-a1f0-5ed4-aa90-3f1a0e2d09fc@ethertronics.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <50e245a7-60ad-39f1-920e-e8edf5d9a5ab@candelatech.com> (sfid-20170527_233842_005502_85498DF9)
Date: Sat, 27 May 2017 14:38:30 -0700
MIME-Version: 1.0
In-Reply-To: <8e314337-a1f0-5ed4-aa90-3f1a0e2d09fc@ethertronics.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/27/2017 12:25 PM, Norik Dzhandzhapanyan wrote:
> We see this inconsistent/incorrect reporting in our RF chamber.

How different are the values, and did you sniff with a third-party device
to see if it sees the same spikes in RSSI?

Thanks,
Ben

>
> Norik
>
> On 05/27/2017 09:39 AM, Adrian Chadd wrote:
>> On 27 May 2017 at 09:07, Ben Greear <greearb@candelatech.com> wrote:
>>> At low encoding rates, especially if it switches to a single-chain encoding,
>>> maybe the on-air signal really is stronger?
>>>
>>> Have you verified in some other manner than the signals reported by ath10k
>>> are
>>> wrong?
>> Hiya,
>>
>> So yeah, multipath, higher TX rates == weaker TX signal, TPC, etc are
>> all interesting to know about at the receiver. it's hard to separate
>> that out from the noise sometimes, but in some controlled deployments
>> its really obvious.
>>
>>
>>
>> -adrian
>>
>>
>
>
> The contents of this transmission are Ethertronics Inc. Confidential and may contain proprietary or legally privileged information which may not be disclosed, copied or distributed without the express written consent of Ethertronics Inc. The information is intended to be for the use of the individual or entity named on this transmission. If you are not the intended recipient, be aware that any disclosure, copying, distribution or use of the contents of this information is prohibited. If you have received this transmission in error, please notify us by telephone immediately so that we can arrange for the retrieval of the original documents at no cost to you. Alternatively, notify the sender by replying to this transmission and delete the message without disclosing it. Thank you
>

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

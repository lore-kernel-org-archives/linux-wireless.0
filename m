Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-sn1nam02on0041.outbound.protection.outlook.com ([104.47.36.41]:47104
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750740AbdE0TbW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 27 May 2017 15:31:22 -0400
Subject: Re: [PATCH] Per chain RSSI reporting
To: Michael Ney <neym@vorklift.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
CC: Ben Greear <greearb@candelatech.com>,
        Adrian Chadd <adrian@freebsd.org>
References: <SN1PR08MB1373BF583E9CE2AA6A0F6381B0FC0@SN1PR08MB1373.namprd08.prod.outlook.com>
 <CAJ-VmomiKOgV4pJWNKdOCzsUJZYEixvP4p5bQ9X1FBqAGk_o0w@mail.gmail.com>
 <SN1PR08MB137316C4132262145C58CEA3B0FD0@SN1PR08MB1373.namprd08.prod.outlook.com>
 <21095854-07c7-7586-6a6e-e60c11932b84@candelatech.com>
 <CAJ-Vmonp72WpT_aUVo_To+k676Ra8S165efPOyXRvvk=_W0YEQ@mail.gmail.com>
 <4A8583B3-FFB2-4BDE-8041-9478CAD9EF73@vorklift.com>
From: Norik Dzhandzhapanyan <norikd@ethertronics.com>
Message-ID: <27cddbb1-4c05-c014-e489-f005d38653d6@ethertronics.com> (sfid-20170527_213126_470757_84D34AC4)
Date: Sat, 27 May 2017 12:31:14 -0700
MIME-Version: 1.0
In-Reply-To: <4A8583B3-FFB2-4BDE-8041-9478CAD9EF73@vorklift.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Is there an enhanced or conflicting patch pending?


On 05/27/2017 10:56 AM, Michael Ney wrote:
> The submitted code also doesn't appear to handle RSSI per-peer which woul=
d be needed for any use when configured as an access point.
>
>> On May 27, 2017, at 12:39 PM, Adrian Chadd <adrian@freebsd.org> wrote:
>>
>> On 27 May 2017 at 09:07, Ben Greear <greearb@candelatech.com> wrote:
>>> At low encoding rates, especially if it switches to a single-chain enco=
ding,
>>> maybe the on-air signal really is stronger?
>>>
>>> Have you verified in some other manner than the signals reported by ath=
10k
>>> are
>>> wrong?
>> Hiya,
>>
>> So yeah, multipath, higher TX rates =3D=3D weaker TX signal, TPC, etc ar=
e
>> all interesting to know about at the receiver. it's hard to separate
>> that out from the noise sometimes, but in some controlled deployments
>> its really obvious.
>>
>>
>>
>> -adrian
>>
>> _______________________________________________
>> ath10k mailing list
>> ath10k@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/ath10k

The contents of this transmission are Ethertronics Inc. Confidential and ma=
y contain proprietary or legally privileged information which may not be di=
sclosed, copied or distributed without the express written consent of Ether=
tronics Inc. The information is intended to be for the use of the individua=
l or entity named on this transmission. If you are not the intended recipie=
nt, be aware that any disclosure, copying, distribution or use of the conte=
nts of this information is prohibited. If you have received this transmissi=
on in error, please notify us by telephone immediately so that we can arran=
ge for the retrieval of the original documents at no cost to you. Alternati=
vely, notify the sender by replying to this transmission and delete the mes=
sage without disclosing it. Thank you

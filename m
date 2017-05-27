Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-dm3nam03on0040.outbound.protection.outlook.com ([104.47.41.40]:44278
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750732AbdE0TZT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 27 May 2017 15:25:19 -0400
From: Norik Dzhandzhapanyan <norikd@ethertronics.com>
To: Adrian Chadd <adrian@freebsd.org>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Ben Greear <greearb@candelatech.com>
Subject: Re: [PATCH] Per chain RSSI reporting
References: <SN1PR08MB1373BF583E9CE2AA6A0F6381B0FC0@SN1PR08MB1373.namprd08.prod.outlook.com>
 <CAJ-VmomiKOgV4pJWNKdOCzsUJZYEixvP4p5bQ9X1FBqAGk_o0w@mail.gmail.com>
 <SN1PR08MB137316C4132262145C58CEA3B0FD0@SN1PR08MB1373.namprd08.prod.outlook.com>
 <21095854-07c7-7586-6a6e-e60c11932b84@candelatech.com>
 <CAJ-Vmonp72WpT_aUVo_To+k676Ra8S165efPOyXRvvk=_W0YEQ@mail.gmail.com>
Message-ID: <8e314337-a1f0-5ed4-aa90-3f1a0e2d09fc@ethertronics.com> (sfid-20170527_212530_805583_49F69D5C)
Date: Sat, 27 May 2017 12:25:10 -0700
MIME-Version: 1.0
In-Reply-To: <CAJ-Vmonp72WpT_aUVo_To+k676Ra8S165efPOyXRvvk=_W0YEQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We see this inconsistent/incorrect reporting in our RF chamber.

Norik

On 05/27/2017 09:39 AM, Adrian Chadd wrote:
> On 27 May 2017 at 09:07, Ben Greear <greearb@candelatech.com> wrote:
>> At low encoding rates, especially if it switches to a single-chain encod=
ing,
>> maybe the on-air signal really is stronger?
>>
>> Have you verified in some other manner than the signals reported by ath1=
0k
>> are
>> wrong?
> Hiya,
>
> So yeah, multipath, higher TX rates =3D=3D weaker TX signal, TPC, etc are
> all interesting to know about at the receiver. it's hard to separate
> that out from the noise sometimes, but in some controlled deployments
> its really obvious.
>
>
>
> -adrian
>
>


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

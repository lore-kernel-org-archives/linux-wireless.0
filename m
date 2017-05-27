Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail1.g8.pair.com ([66.39.4.88]:33033 "EHLO mail1.g8.pair.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750727AbdE0SGR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 27 May 2017 14:06:17 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH] Per chain RSSI reporting
From: Michael Ney <neym@vorklift.com>
In-Reply-To: <CAJ-Vmonp72WpT_aUVo_To+k676Ra8S165efPOyXRvvk=_W0YEQ@mail.gmail.com>
Date: Sat, 27 May 2017 13:56:54 -0400
Cc: Ben Greear <greearb@candelatech.com>,
        Norik Dzhandzhapanyan <norikd@ethertronics.com>,
        Adrian Chadd <adrian@freebsd.org>
Message-Id: <4A8583B3-FFB2-4BDE-8041-9478CAD9EF73@vorklift.com> (sfid-20170527_200627_301094_7227850E)
References: <SN1PR08MB1373BF583E9CE2AA6A0F6381B0FC0@SN1PR08MB1373.namprd08.prod.outlook.com>
 <CAJ-VmomiKOgV4pJWNKdOCzsUJZYEixvP4p5bQ9X1FBqAGk_o0w@mail.gmail.com>
 <SN1PR08MB137316C4132262145C58CEA3B0FD0@SN1PR08MB1373.namprd08.prod.outlook.com>
 <21095854-07c7-7586-6a6e-e60c11932b84@candelatech.com>
 <CAJ-Vmonp72WpT_aUVo_To+k676Ra8S165efPOyXRvvk=_W0YEQ@mail.gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The submitted code also doesn't appear to handle RSSI per-peer which would be needed for any use when configured as an access point.

> On May 27, 2017, at 12:39 PM, Adrian Chadd <adrian@freebsd.org> wrote:
> 
> On 27 May 2017 at 09:07, Ben Greear <greearb@candelatech.com> wrote:
>> At low encoding rates, especially if it switches to a single-chain encoding,
>> maybe the on-air signal really is stronger?
>> 
>> Have you verified in some other manner than the signals reported by ath10k
>> are
>> wrong?
> 
> Hiya,
> 
> So yeah, multipath, higher TX rates == weaker TX signal, TPC, etc are
> all interesting to know about at the receiver. it's hard to separate
> that out from the noise sometimes, but in some controlled deployments
> its really obvious.
> 
> 
> 
> -adrian
> 
> _______________________________________________
> ath10k mailing list
> ath10k@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/ath10k

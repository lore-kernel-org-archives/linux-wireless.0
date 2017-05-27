Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f170.google.com ([209.85.128.170]:33246 "EHLO
        mail-wr0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750714AbdE0Qjb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 27 May 2017 12:39:31 -0400
Received: by mail-wr0-f170.google.com with SMTP id w50so15699364wrc.0
        for <linux-wireless@vger.kernel.org>; Sat, 27 May 2017 09:39:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <21095854-07c7-7586-6a6e-e60c11932b84@candelatech.com>
References: <SN1PR08MB1373BF583E9CE2AA6A0F6381B0FC0@SN1PR08MB1373.namprd08.prod.outlook.com>
 <CAJ-VmomiKOgV4pJWNKdOCzsUJZYEixvP4p5bQ9X1FBqAGk_o0w@mail.gmail.com>
 <SN1PR08MB137316C4132262145C58CEA3B0FD0@SN1PR08MB1373.namprd08.prod.outlook.com>
 <21095854-07c7-7586-6a6e-e60c11932b84@candelatech.com>
From: Adrian Chadd <adrian@freebsd.org>
Date: Sat, 27 May 2017 09:39:29 -0700
Message-ID: <CAJ-Vmonp72WpT_aUVo_To+k676Ra8S165efPOyXRvvk=_W0YEQ@mail.gmail.com> (sfid-20170527_183935_533778_07C00D50)
Subject: Re: [PATCH] Per chain RSSI reporting
To: Ben Greear <greearb@candelatech.com>
Cc: Norik Dzhandzhapanyan <norikd@ethertronics.com>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 27 May 2017 at 09:07, Ben Greear <greearb@candelatech.com> wrote:
> At low encoding rates, especially if it switches to a single-chain encoding,
> maybe the on-air signal really is stronger?
>
> Have you verified in some other manner than the signals reported by ath10k
> are
> wrong?

Hiya,

So yeah, multipath, higher TX rates == weaker TX signal, TPC, etc are
all interesting to know about at the receiver. it's hard to separate
that out from the noise sometimes, but in some controlled deployments
its really obvious.



-adrian

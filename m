Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:42457 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755869AbdKJCeB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Nov 2017 21:34:01 -0500
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>,
        Dave Taht <dave.taht@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: "make-wifi-fast\@lists.bufferbloat.net"
        <make-wifi-fast@lists.bufferbloat.net>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k\@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: RE: [Make-wifi-fast] [PATCH] ath10k: Re-enable TXQs for all devices
In-Reply-To: <a7b75767d01b46ef818f86dbd0c657a8@NALASEXR01H.na.qualcomm.com>
References: <20171109071945.11033-1-toke@toke.dk> <6112ae948ba2409da27709d01da567eb@NALASEXR01H.na.qualcomm.com> <87k1yzq9i8.fsf@toke.dk> <CAA93jw6yw5=ALMdRaRrGU9uySmov9HwM-mr2npRbzsSxHgSAGw@mail.gmail.com> <a7b75767d01b46ef818f86dbd0c657a8@NALASEXR01H.na.qualcomm.com>
Date: Fri, 10 Nov 2017 11:33:53 +0900
Message-ID: <87h8u2rhf2.fsf@toke.dk> (sfid-20171110_033412_062336_37E6C011)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:

> Agree.. Even I am not fan of that patch in ath10k. IIRC Michal pushed
> this change as temp one and planned to revert it once it is fixed in
> stack or in driver.
>
> I thought Eric change in fq_codel is meant only for fatty udp flows.
> Forgive my ignorance.

It is, mostly. There's a separate possible issue with TCP performance
that we're looking into, but that is unrelated to TXQs.

-Toke

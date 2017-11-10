Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:59283 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754502AbdKJAKQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Nov 2017 19:10:16 -0500
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>,
        "make-wifi-fast\@lists.bufferbloat.net"
        <make-wifi-fast@lists.bufferbloat.net>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH] ath10k: Re-enable TXQs for all devices
In-Reply-To: <6112ae948ba2409da27709d01da567eb@NALASEXR01H.na.qualcomm.com>
References: <20171109071945.11033-1-toke@toke.dk> <6112ae948ba2409da27709d01da567eb@NALASEXR01H.na.qualcomm.com>
Date: Fri, 10 Nov 2017 09:10:07 +0900
Message-ID: <87k1yzq9i8.fsf@toke.dk> (sfid-20171110_011020_142002_44F8C9DC)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:

>> Commit 4ca1807815aa6801aaced7fdefa9edacc2521767 disables the use of the
>> mac80211 TXQs for some devices because of a theoretical throughput
>> regression. We have not seen this regression for a while now, so it shou=
ld be
>> safe to re-enable TXQs.
>>=20
>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
>> ---
>> This has been in LEDE trunk for a couple of months now with good results.
>>
> Toke,
>=20=20
> Good to know that the performance drop is not seen with the chips that do=
es not
> have push-pull support. The issue was originally reported with ap152 + qc=
a988x
> by community [1]. Hope this combination is also considered in LEDE.

Ah, was that the original bug report? Thank you, I have not been able to
find that anywhere!

The issue that seems to point to has been fixed a while ago; I'll send
and updated patch with a better commit message (also forgot to cc the
ath10k list, I see).

-Toke

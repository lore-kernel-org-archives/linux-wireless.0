Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:36443 "EHLO
        mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750796AbcL1Nvr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Dec 2016 08:51:47 -0500
MIME-Version: 1.0
In-Reply-To: <CACna6rzKc8kAnc2_Ca8pXtuu9Rw2mjqfV8VNumoF_E7GdvJx-g@mail.gmail.com>
References: <20160905095128.80560-1-nbd@nbd.name> <201609301636.43363.arnd@arndb.de>
 <557be2b8-5ff1-83ea-f6d1-6421c2465969@nbd.name> <201609301658.35039.arnd@arndb.de>
 <87vax9r26s.fsf@kamboji.qca.qualcomm.com> <CACna6ryikdd0Yt2FWB_JT27N5uuh9XU+JUWNRjs4H5YcD5PVpw@mail.gmail.com>
 <CAFBinCBzz0Jvk_jcWAJ1jEz17r-NYEE87xLUACTybRSHGE7uGA@mail.gmail.com> <CACna6rzKc8kAnc2_Ca8pXtuu9Rw2mjqfV8VNumoF_E7GdvJx-g@mail.gmail.com>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Wed, 28 Dec 2016 14:51:45 +0100
Message-ID: <CACna6rzxtJ96tGUmy_k1wAtDu8z=vsJXw5SmHvr3+1=gD++Frg@mail.gmail.com> (sfid-20161228_145156_423107_24C29C47)
Subject: Re: [PATCH v3 1/3] Documentation: dt: net: add mt76 wireless device binding
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        Felix Fietkau <nbd@nbd.name>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 28 December 2016 at 14:28, Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> wr=
ote:
> On 28 December 2016 at 11:43, Martin Blumenstingl
> <martin.blumenstingl@googlemail.com> wrote:
>> should we describe the center freq in Hz or MHz (cfg80211's
>> ieee80211_channel uses the latter)?
>
> Is there any case that may require HZ accuracy? I was thinking about usin=
g MHz.

Regulatory code uses KHz, so we may better do the same.

--=20
Rafa=C5=82

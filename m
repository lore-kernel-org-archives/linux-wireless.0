Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:32790 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751610AbdAQXR1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Jan 2017 18:17:27 -0500
MIME-Version: 1.0
In-Reply-To: <20170117225545.6706-1-gavinli@thegavinli.com>
References: <20170117225545.6706-1-gavinli@thegavinli.com>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Wed, 18 Jan 2017 00:09:22 +0100
Message-ID: <CACna6rxiNPkttfR+K5GMn1ZiaW-KZyNn3S4i9brkRE7zLE8BCw@mail.gmail.com> (sfid-20170118_001732_317089_733D71F8)
Subject: Re: [PATCH] brcmfmac: fix incorrect event channel deduction
To: gavinli@thegavinli.com
Cc: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
        <brcm80211-dev-list.pdl@broadcom.com>,
        Stable <stable@vger.kernel.org>, Gavin Li <git@thegavinli.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17 January 2017 at 23:55,  <gavinli@thegavinli.com> wrote:
> From: Gavin Li <git@thegavinli.com>
>
> brcmf_sdio_fromevntchan() was being called on the the data frame
> rather than the software header, causing some frames to be
> mischaracterized as on the event channel rather than the data channel.
>
> This fixes a major performance regression (due to dropped packets).
>
> Fixes: c56caa9db8ab ("brcmfmac: screening firmware event packet")
> Signed-off-by: Gavin Li <git@thegavinli.com>
> Cc: <stable@vger.kernel.org> [4.6+]

Oh, that was supposed to be 4.7+, I gave you a wrong hint, sorry!

You may send V3, or maybe ask Kalle to fix it by hand when applying the pat=
ch.

--=20
Rafa=C5=82

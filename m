Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:46193 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754373AbeFYIpy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Jun 2018 04:45:54 -0400
Received: by mail-wr0-f194.google.com with SMTP id l14-v6so7684207wrq.13
        for <linux-wireless@vger.kernel.org>; Mon, 25 Jun 2018 01:45:53 -0700 (PDT)
MIME-Version: 1.0
References: <1529693004-20569-1-git-send-email-arend.vanspriel@broadcom.com>
 <CACna6rwzS-KXZ80wudpNEcrtnPd7fUWYKbT93hfFMfQi-V-hhg@mail.gmail.com> <5B30A542.7090400@broadcom.com>
In-Reply-To: <5B30A542.7090400@broadcom.com>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Mon, 25 Jun 2018 10:43:36 +0200
Message-ID: <CACna6rxg4GHkN_65c2RHBGrWw5NK=ocqY2JTTfWFX0HJmKW6xA@mail.gmail.com> (sfid-20180625_104704_039637_D3CEBAB7)
Subject: Re: [PATCH 0/6] brcmfmac: fix 160MHz support and monitor mode
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 25 Jun 2018 at 10:18, Arend van Spriel
<arend.vanspriel@broadcom.com> wrote:
> On 6/24/2018 1:48 PM, Rafa=C5=82 Mi=C5=82ecki wrote:
> > On Fri, 22 Jun 2018 at 20:45, Arend van Spriel
> > <arend.vanspriel@broadcom.com> wrote:
> >> Here a couple of patches in preparation of monitor mode support. It
> >> is mostly about querying firmware for support. While at it I stumbled
> >> upon the fact that 160MHz was not completely implemented in the driver
> >> so there is a patch for that as well.
> >>
> >> The first two patches are actually some changes to the patches that
> >> Rafal submitted. So this series depend on:
> >>
> >> [V3,2/2] brcmfmac: handle monitor mode marked msgbuf packets [1]
> >>
> >> These apply to the master branch of the wireless-drivers-next reposito=
ry.
> >>
> >> [1] https://patchwork.kernel.org/patch/10474799/
> >
> > I find it pointless to submit fixes for patches that weren't accepted
> > yet. Let's work on improving original patches while they are still
> > pending.
>
> It is not unprecedented. There are enough patch series sent in the past
> that relied on other still pending series. I was unsure how to deal with
> it as I acked your changes already and did not exactly know when Kalle
> would start applying the patches. I am fine either way.

Well, things happen, I don't mind if you un-ack my patch, after
discovering some problem with it :)

--=20
Rafa=C5=82

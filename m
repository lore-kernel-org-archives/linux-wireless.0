Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:55277 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbeIESWK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Sep 2018 14:22:10 -0400
Received: by mail-wm0-f65.google.com with SMTP id c14-v6so8082988wmb.4
        for <linux-wireless@vger.kernel.org>; Wed, 05 Sep 2018 06:51:50 -0700 (PDT)
MIME-Version: 1.0
References: <1529693004-20569-1-git-send-email-arend.vanspriel@broadcom.com>
 <CACna6rwzS-KXZ80wudpNEcrtnPd7fUWYKbT93hfFMfQi-V-hhg@mail.gmail.com>
 <CACna6rzpUDWBR_SXciEo8Z3Fsa6VZT0-KL2=WCzz9v8ww6tZVA@mail.gmail.com>
 <5B30A85C.5080105@broadcom.com> <CACna6ryvEmgo6LKHsOGj_kcjZcFrFqTOV1EDtCN=oRd5BO5uWw@mail.gmail.com>
 <5B8FB8C2.2040200@broadcom.com>
In-Reply-To: <5B8FB8C2.2040200@broadcom.com>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Wed, 5 Sep 2018 15:51:37 +0200
Message-ID: <CACna6rye_PFFKvYF4xQtLb2YaT2S7zH2TSg2gj9+xd7Yw7ucmA@mail.gmail.com> (sfid-20180905_155154_669575_E9139C69)
Subject: Re: [PATCH 0/6] brcmfmac: fix 160MHz support and monitor mode
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 5 Sep 2018 at 13:06, Arend van Spriel
<arend.vanspriel@broadcom.com> wrote:
> On 8/29/2018 10:17 PM, Rafa=C5=82 Mi=C5=82ecki wrote:
> > Hi Arend,
> >
> > On Mon, 25 Jun 2018 at 10:31, Arend van Spriel
> > <arend.vanspriel@broadcom.com> wrote:
> >> On 6/25/2018 6:40 AM, Rafa=C5=82 Mi=C5=82ecki wrote:
> >>> On Sun, 24 Jun 2018 at 13:48, Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.c=
om> wrote:
> >>>> On Fri, 22 Jun 2018 at 20:45, Arend van Spriel
> >>>> <arend.vanspriel@broadcom.com> wrote:
> >>>>> Here a couple of patches in preparation of monitor mode support. It
> >>>>> is mostly about querying firmware for support. While at it I stumbl=
ed
> >>>>> upon the fact that 160MHz was not completely implemented in the dri=
ver
> >>>>> so there is a patch for that as well.
> >>>>>
> >>>>> The first two patches are actually some changes to the patches that
> >>>>> Rafal submitted. So this series depend on:
> >>>>>
> >>>>> [V3,2/2] brcmfmac: handle monitor mode marked msgbuf packets [1]
> >>>>>
> >>>>> These apply to the master branch of the wireless-drivers-next repos=
itory.
> >>>>>
> >>>>> [1] https://patchwork.kernel.org/patch/10474799/
> >>>>
> >>>> I find it pointless to submit fixes for patches that weren't accepte=
d
> >>>> yet. Let's work on improving original patches while they are still
> >>>> pending.
> >>>
> >>> I sent V4 with changes pointed our by Arend. That obsoletes all (?)
> >>> monitor patches from this patchset. I believe it was cleaner to
> >>> improve original patchset (not pushed yet).
> >>>
> >>> My suggestion is to apply patches 3/6 and 4/6 (they aren't monitor
> >>> related) and drop the others.
> >>
> >> Well. Given that Kalle prefers applying "all-or-nothing" I will resubm=
it
> >> the series addressing the issues you found.
> >
> > Would you have a moment to resubmit these 2 patches or do you mind if I=
 do that?
>
> Found a moment. Should be in patchwork now.

Thank you! :)

--=20
Rafa=C5=82

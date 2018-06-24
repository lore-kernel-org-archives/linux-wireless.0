Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35238 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750797AbeFXLub (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 24 Jun 2018 07:50:31 -0400
Received: by mail-wm0-f66.google.com with SMTP id z137-v6so1300332wmc.0
        for <linux-wireless@vger.kernel.org>; Sun, 24 Jun 2018 04:50:30 -0700 (PDT)
MIME-Version: 1.0
References: <1529693004-20569-1-git-send-email-arend.vanspriel@broadcom.com>
In-Reply-To: <1529693004-20569-1-git-send-email-arend.vanspriel@broadcom.com>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Sun, 24 Jun 2018 13:48:21 +0200
Message-ID: <CACna6rwzS-KXZ80wudpNEcrtnPd7fUWYKbT93hfFMfQi-V-hhg@mail.gmail.com> (sfid-20180624_135034_836907_FE722252)
Subject: Re: [PATCH 0/6] brcmfmac: fix 160MHz support and monitor mode
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 22 Jun 2018 at 20:45, Arend van Spriel
<arend.vanspriel@broadcom.com> wrote:
> Here a couple of patches in preparation of monitor mode support. It
> is mostly about querying firmware for support. While at it I stumbled
> upon the fact that 160MHz was not completely implemented in the driver
> so there is a patch for that as well.
>
> The first two patches are actually some changes to the patches that
> Rafal submitted. So this series depend on:
>
> [V3,2/2] brcmfmac: handle monitor mode marked msgbuf packets [1]
>
> These apply to the master branch of the wireless-drivers-next repository.
>
> [1] https://patchwork.kernel.org/patch/10474799/

I find it pointless to submit fixes for patches that weren't accepted
yet. Let's work on improving original patches while they are still
pending.

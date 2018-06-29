Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53782 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752452AbeF2HD1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Jun 2018 03:03:27 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Chung-Hsien Hsu <stanley.hsu@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: Re: [PATCH V4 2/3] brcmfmac: detect firmware support for radiotap monitor frames
References: <20180624194437.28766-1-zajec5@gmail.com>
        <20180624194437.28766-2-zajec5@gmail.com>
Date: Fri, 29 Jun 2018 10:03:20 +0300
In-Reply-To: <20180624194437.28766-2-zajec5@gmail.com> (=?utf-8?Q?=22Rafa?=
 =?utf-8?Q?=C5=82_Mi=C5=82ecki=22's?=
        message of "Sun, 24 Jun 2018 21:44:36 +0200")
Message-ID: <87wouif51j.fsf@codeaurora.org> (sfid-20180629_090331_076000_8E633343)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> writes:

> From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>
> Depending on used build-time options some firmwares may already include
> radiotap header in passed monitor frames. Add a new feature flag to
> store info about it. It's needed for proper handling of received frames
> before passing them up.
>
> Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>

BTW, we now have Co-Developed-by:

https://www.kernel.org/doc/html/latest/process/submitting-patches.html#when=
-to-use-acked-by-cc-and-co-developed-by

But no need to change this patch, just a tip for the future. I assume
this patchset is good to go and will apply it soon.

--=20
Kalle Valo

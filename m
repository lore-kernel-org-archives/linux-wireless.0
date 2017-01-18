Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36796 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751157AbdARIDv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Jan 2017 03:03:51 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: Re: [PATCH] brcmfmac: use wiphy_read_of_freq_limits to respect limits from DT
References: <20170117223550.12114-1-zajec5@gmail.com>
Date: Wed, 18 Jan 2017 10:03:45 +0200
In-Reply-To: <20170117223550.12114-1-zajec5@gmail.com> (=?utf-8?Q?=22Rafa?=
 =?utf-8?Q?=C5=82_Mi=C5=82ecki=22's?=
        message of "Tue, 17 Jan 2017 23:35:50 +0100")
Message-ID: <87wpdsn6am.fsf@kamboji.qca.qualcomm.com> (sfid-20170118_090354_477688_FE4FD42F)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> writes:

> From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>
> This new helper reads extra frequency limits specified in DT and
> disables unavailable chanels. This is useful for devices (like home
> routers) with chipsets limited e.g. by board design.
>
> In order to respect info read from DT we simply need to check for
> IEEE80211_CHAN_DISABLED bit when constructing channel info.
>
> Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
> ---
> This patch requires e691ac2f75b6 ("cfg80211: support ieee80211-freq-limit=
 DT
> property") that is currently in net-next.
>
> Kalle: feel free to postpone this until merging net-next one day.

Thanks for documenting the dependency perfectly, makes my work a lot
easier. I'm expecting to merge net-next after my next pull request, most
likely early next week.

--=20
Kalle Valo

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43316 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933028AbeCSQXp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Mar 2018 12:23:45 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Alexey Roslyakov <alexey.roslyakov@gmail.com>
Cc: andrew@lunn.ch, robh+dt@kernel.org, mark.rutland@arm.com,
        arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@cypress.com,
        wright.feng@cypress.com, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com
Subject: Re: [PATCH net-next v2 1/2] brcmfmac: add new dt entries for SG SDIO settings
References: <20180319014032.9394-1-alexey.roslyakov@gmail.com>
        <20180319014032.9394-2-alexey.roslyakov@gmail.com>
Date: Mon, 19 Mar 2018 18:23:29 +0200
In-Reply-To: <20180319014032.9394-2-alexey.roslyakov@gmail.com> (Alexey
        Roslyakov's message of "Mon, 19 Mar 2018 08:40:31 +0700")
Message-ID: <877eq8yqym.fsf@kamboji.qca.qualcomm.com> (sfid-20180319_172449_918465_51012F39)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Alexey Roslyakov <alexey.roslyakov@gmail.com> writes:

> There are 3 fields in SDIO settings (quirks) to workaround some of the
> SG SDIO host particularities, i.e higher align requirements for SG
> items. All coding is done the long time ago, but there is no way to
> change the driver behavior without patching the kernel. Add missing
> devicetree entries.
>
> Signed-off-by: Alexey Roslyakov <alexey.roslyakov@gmail.com>

The commit log is not clear for me, what does "all coding is done long
time ago" exactly mean? What code and where?

>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)

Why net-next? To me it looks like this should go to
wireless-drivers-next.

-- 
Kalle Valo

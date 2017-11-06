Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49052 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751875AbdKFKnv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Nov 2017 05:43:51 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Simon Shields <simon@lineageos.org>
Cc: devicetree@vger.kernel.org, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>
Subject: Re: [PATCH] brcmfmac: add support for external 32khz clock
References: <20171106102934.GA23805@lineageos.org>
Date: Mon, 06 Nov 2017 12:43:46 +0200
In-Reply-To: <20171106102934.GA23805@lineageos.org> (Simon Shields's message
        of "Mon, 6 Nov 2017 21:29:40 +1100")
Message-ID: <87fu9rk7q5.fsf@codeaurora.org> (sfid-20171106_114355_286730_961825FD)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Simon Shields <simon@lineageos.org> writes:

> Some boards use an external 32khz clock for low-power
> mode timing. Make sure the clock is powered on while the chipset
> is active.
>
> Signed-off-by: Simon Shields <simon@lineageos.org>

Then you submit a new version please always increase the version so that
I know which patch I should follow and take from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#patch_version_missing

And yes yes, I know the patch content was identical in this case but
even a change in Cc field is important from my point of view. No need to
resend, this reply is also a reminder to me that this is the v2 :)

-- 
Kalle Valo

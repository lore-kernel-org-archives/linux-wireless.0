Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43442 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934746AbeF0Pzs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Jun 2018 11:55:48 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: brcmsmac: Remove unnecessary parentheses
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180601021413.4031-1-rvarsha016@gmail.com>
References: <20180601021413.4031-1-rvarsha016@gmail.com>
To: Varsha Rao <rvarsha016@gmail.com>
Cc: Nicholas Mc Guire <der.herr@hofr.at>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Varsha Rao <rvarsha016@gmail.com>
Message-Id: <20180627155548.0D0CF60AD8@smtp.codeaurora.org> (sfid-20180627_175633_315984_96871149)
Date: Wed, 27 Jun 2018 15:55:47 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Varsha Rao <rvarsha016@gmail.com> wrote:

> This patch fixes the clang warning of extraneous parentheses, with the
> following coccinelle script.
> 
> @@
> identifier i;
> expression e;
> statement s;
> @@
> if (
> -(i == e)
> +i == e
>  )
> s
> 
> Suggested-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> Signed-off-by: Varsha Rao <rvarsha016@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

eb5d2f3afc0f brcmsmac: Remove unnecessary parentheses

-- 
https://patchwork.kernel.org/patch/10442401/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

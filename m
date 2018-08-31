Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56436 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727574AbeHaTt5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Aug 2018 15:49:57 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH] brcmsmac: Remove extra parentheses
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180725185625.4220-1-rvarsha016@gmail.com>
References: <20180725185625.4220-1-rvarsha016@gmail.com>
To: Varsha Rao <rvarsha016@gmail.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Nicholas Mc Guire <der.herr@hofr.at>,
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
Message-Id: <20180831154153.81C176053D@smtp.codeaurora.org> (sfid-20180831_174156_131629_7407EC26)
Date: Fri, 31 Aug 2018 15:41:53 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Varsha Rao <rvarsha016@gmail.com> wrote:

> Remove the unnecessary parentheses to fix the clang warning of
> extraneous parentheses.
> 
> Signed-off-by: Varsha Rao <rvarsha016@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

9e9e11d83238 brcmsmac: Remove extra parentheses

-- 
https://patchwork.kernel.org/patch/10544573/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

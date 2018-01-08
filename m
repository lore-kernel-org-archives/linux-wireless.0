Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53266 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751843AbeAHRVK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Jan 2018 12:21:10 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] brcmfmac: Support 43455 save-restore (SR) feature if FW
 include -sr
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1513666604-24592-1-git-send-email-wright.feng@cypress.com>
References: <1513666604-24592-1-git-send-email-wright.feng@cypress.com>
To: Wright Feng <wright.feng@cypress.com>
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@cypress.com,
        wright.feng@cypress.com, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        Double Lo <double.lo@cypress.com>
Message-Id: <20180108172109.8BFB160B1B@smtp.codeaurora.org> (sfid-20180108_182117_451828_6F5DC4DF)
Date: Mon,  8 Jan 2018 17:21:09 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wright Feng <wright.feng@cypress.com> wrote:

> From: Double Lo <double.lo@cypress.com>
> 
> This patch will add 43455 into the save-restore(SR) capable chip list, so
> the SR engine will be enabled with 43455 FW which built-in the -sr
> function.
> 
> Signed-off-by: Double Lo <double.lo@cypress.com>
> Signed-off-by: Wright Feng <wright.feng@cypress.com>

Patch applied to wireless-drivers-next.git, thanks.

e3720dad9985 brcmfmac: Support 43455 save-restore (SR) feature if FW include -sr

-- 
https://patchwork.kernel.org/patch/10122587/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

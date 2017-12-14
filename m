Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43492 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751755AbdLNMjo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Dec 2017 07:39:44 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: brcmfmac: Support 43455 save-restore (SR) feature if FW include
 -sr
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1512639183-3357-1-git-send-email-wright.feng@cypress.com>
References: <1512639183-3357-1-git-send-email-wright.feng@cypress.com>
To: Wright Feng <wright.feng@cypress.com>
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@cypress.com,
        wright.feng@cypress.com, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        Double Lo <double.lo@cypress.com>
Message-Id: <20171214123944.12BEB6020A@smtp.codeaurora.org> (sfid-20171214_133948_387648_7E076939)
Date: Thu, 14 Dec 2017 12:39:44 +0000 (UTC)
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

Wright's s-o-b is missing:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#signed-off-by_missing

-- 
https://patchwork.kernel.org/patch/10097897/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

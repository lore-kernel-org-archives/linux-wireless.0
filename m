Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51326 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751880AbdHHLwW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Aug 2017 07:52:22 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: brcmfmac: add setting carrier state ON for successful roaming
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1502093812-5011-1-git-send-email-wright.feng@cypress.com>
References: <1502093812-5011-1-git-send-email-wright.feng@cypress.com>
To: Wright Feng <wright.feng@cypress.com>
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@cypress.com,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, wright.feng@cypress.com,
        Chung-Hsien Hsu <stanley.hsu@cypress.com>
Message-Id: <20170808115221.B668560310@smtp.codeaurora.org> (sfid-20170808_135225_071398_D7C9A60C)
Date: Tue,  8 Aug 2017 11:52:21 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wright Feng <wright.feng@cypress.com> wrote:

> From: Chung-Hsien Hsu <stanley.hsu@cypress.com>
> 
> After association, ping is not working when sweeping the channel at the
> AP side. It is caused by having incorrect carrier state (OFF) for the STA
> in successful roaming. This patch sets the carrier state ON for the case.
> 
> Signed-off-by: Chung-Hsien Hsu <stanley.hsu@cypress.com>
> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Patch applied to wireless-drivers-next.git, thanks.

8b943e36e24a brcmfmac: add setting carrier state ON for successful roaming

-- 
https://patchwork.kernel.org/patch/9884669/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44078 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751839AbdLNMkd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Dec 2017 07:40:33 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: brcmsmac: use ARRAY_SIZE on rfseq_updategainu_events
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20171207102047.21635-1-colin.king@canonical.com>
References: <20171207102047.21635-1-colin.king@canonical.com>
To: Colin Ian King <colin.king@canonical.com>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20171214124032.C48396020A@smtp.codeaurora.org> (sfid-20171214_134046_901921_F3F86B3D)
Date: Thu, 14 Dec 2017 12:40:32 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Colin Ian King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> Use the ARRAY_SIZE macro on rfseq_updategainu_events to determine
> size of the array. Improvement suggested by coccinelle.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Patch applied to wireless-drivers-next.git, thanks.

18907f20ea71 brcmsmac: use ARRAY_SIZE on rfseq_updategainu_events

-- 
https://patchwork.kernel.org/patch/10098257/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

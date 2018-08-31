Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60578 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727824AbeHaTxK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Aug 2018 15:53:10 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] brcmfmac: add FT-based AKMs in brcmf_set_key_mgmt()
 for FT support
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1534329160-131774-2-git-send-email-chi-hsien.lin@cypress.com>
References: <1534329160-131774-2-git-send-email-chi-hsien.lin@cypress.com>
To: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
Cc: linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <wright.feng@cypress.com>,
        Chung-Hsien Hsu <stanley.hsu@cypress.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>
Message-Id: <20180831154505.4A5A06049C@smtp.codeaurora.org> (sfid-20180831_174509_425111_F430AA73)
Date: Fri, 31 Aug 2018 15:45:05 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Chi-Hsien Lin <chi-hsien.lin@cypress.com> wrote:

> From: Chung-Hsien Hsu <stanley.hsu@cypress.com>
> 
> Add WLAN_AKM_SUITE_FT_8021X and WLAN_AKM_SUITE_FT_PSK in
> brcmf_set_key_mgmt() for FT support.
> 
> Signed-off-by: Chung-Hsien Hsu <stanley.hsu@cypress.com>
> Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>

2 patches applied to wireless-drivers-next.git, thanks.

4ad298da9392 brcmfmac: add FT-based AKMs in brcmf_set_key_mgmt() for FT support
a858376cdbb3 brcmfmac: add 4-way handshake offload detection for FT-802.1X

-- 
https://patchwork.kernel.org/patch/10566487/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

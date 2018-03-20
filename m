Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42294 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752228AbeCTKIs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Mar 2018 06:08:48 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: brcmfmac: Fix check for ISO3166 code
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1521054179-4030-1-git-send-email-stefan.wahren@i2se.com>
References: <1521054179-4030-1-git-send-email-stefan.wahren@i2se.com>
To: Stefan Wahren <stefan.wahren@i2se.com>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        Stefan Wahren <stefan.wahren@i2se.com>
Message-Id: <20180320100848.756556025C@smtp.codeaurora.org> (sfid-20180320_110853_912375_12759340)
Date: Tue, 20 Mar 2018 10:08:48 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stefan Wahren <stefan.wahren@i2se.com> wrote:

> The commit "regulatory: add NUL to request alpha2" increases the length of
> alpha2 to 3. This causes a regression on brcmfmac, because
> brcmf_cfg80211_reg_notifier() expect valid ISO3166 codes in the complete
> array. So fix this accordingly.
> 
> Fixes: 657308f73e67 ("regulatory: add NUL to request alpha2")
> Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
> Acked-by: Franky Lin <franky.lin@broadcom.com>

Patch applied to wireless-drivers.git, thanks.

9b9322db5c5a brcmfmac: Fix check for ISO3166 code

-- 
https://patchwork.kernel.org/patch/10283389/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

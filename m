Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59558 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727615AbeH1Rht (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Aug 2018 13:37:49 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH] ath9k: fix tx99 with monitor mode interface
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180820093751.63406-1-nbd@nbd.name>
References: <20180820093751.63406-1-nbd@nbd.name>
To: Felix Fietkau <nbd@nbd.name>
Cc: linux-wireless@vger.kernel.org
Message-Id: <20180828134604.C5CEB6053D@smtp.codeaurora.org> (sfid-20180828_154618_303326_6443192C)
Date: Tue, 28 Aug 2018 13:46:04 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@nbd.name> wrote:

> Tx99 is typically configured via a monitor mode interface, which does
> not get added to the driver as a vif. Since the code currently expects
> a configured virtual interface for tx99, enabling tx99 via debugfs fails.
> Since the vif is not needed anyway, remove all checks for it.
> 
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> [kvalo@codeaurora.org: s/CPTCFG/CONFIG/]
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

d9c52fd17cb4 ath9k: fix tx99 with monitor mode interface

-- 
https://patchwork.kernel.org/patch/10570041/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

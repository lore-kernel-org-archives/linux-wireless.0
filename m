Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54282 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750778AbeELJYz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 12 May 2018 05:24:55 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: hw: make consistent usage of ATH10K_FW_DIR in paths
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180509075633.3030-1-marcus.folkesson@gmail.com>
References: <20180509075633.3030-1-marcus.folkesson@gmail.com>
To: Marcus Folkesson <marcus.folkesson@gmail.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Marcus Folkesson <marcus.folkesson@gmail.com>
Message-Id: <20180512092455.1ABBC601EA@smtp.codeaurora.org> (sfid-20180512_112458_362407_E9B1AB0D)
Date: Sat, 12 May 2018 09:24:55 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Marcus Folkesson <marcus.folkesson@gmail.com> wrote:

> For some reason not all entries used ATH10K_FW_DIR so fix that. No functional
> changes.
> 
> Signed-off-by: Marcus Folkesson <marcus.folkesson@gmail.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

0be928850dac ath10k: hw: make consistent usage of ATH10K_FW_DIR in paths

-- 
https://patchwork.kernel.org/patch/10388585/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

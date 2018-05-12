Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55348 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750778AbeELJ0T (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 12 May 2018 05:26:19 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] ath10k: Replace bit shifts with the BIT() macro for rx desc
 bits
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180509093321.15269-1-govinds@codeaurora.org>
References: <20180509093321.15269-1-govinds@codeaurora.org>
To: Govind Singh <govinds@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
Message-Id: <20180512092619.1BDD960850@smtp.codeaurora.org> (sfid-20180512_112623_040757_856F8538)
Date: Sat, 12 May 2018 09:26:19 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Govind Singh <govinds@codeaurora.org> wrote:

> Use the BIT() macro from 'linux/bitops.h' to define the rx desc
> bit flags to have consistency with new definitions.
> 
> Signed-off-by: Govind Singh <govinds@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

c3f7f31efe39 ath10k: replace bit shifts with the BIT() macro for rx desc bits

-- 
https://patchwork.kernel.org/patch/10388887/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

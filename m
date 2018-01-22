Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48550 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751098AbeAVGPo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Jan 2018 01:15:44 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: wcn36xx: release resources in case of error
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180118143356.14290-1-rfried@codeaurora.org>
References: <20180118143356.14290-1-rfried@codeaurora.org>
To: Ramon Fried <rfried@codeaurora.org>
Cc: k.eugene.e@gmail.com, bjorn.andersson@linaro.org,
        wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Ramon Fried <rfried@codeaurora.org>
Message-Id: <20180122061543.E2E30601CF@smtp.codeaurora.org> (sfid-20180122_071551_873655_221F4B7D)
Date: Mon, 22 Jan 2018 06:15:43 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ramon Fried <rfried@codeaurora.org> wrote:

> wcn36xx_dxe_init() doesn't check for the return value
> of wcn36xx_dxe_init_descs().
> This patch releases the resources in case an error ocurred.
> 
> Signed-off-by: Ramon Fried <rfried@codeaurora.org>

This is a duplicate.

Patch set to Superseded.

-- 
https://patchwork.kernel.org/patch/10173331/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

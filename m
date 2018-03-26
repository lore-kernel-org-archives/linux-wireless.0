Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44404 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751865AbeCZP1D (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Mar 2018 11:27:03 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: wcn36xx: calculate DXE default channel values
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180311120118.29671-1-rfried@codeaurora.org>
References: <20180311120118.29671-1-rfried@codeaurora.org>
To: Ramon Fried <rfried@codeaurora.org>
Cc: k.eugene.e@gmail.com, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, Ramon Fried <rfried@codeaurora.org>
Message-Id: <20180326152702.A9C396071A@smtp.codeaurora.org> (sfid-20180326_172706_604072_5FF5D26E)
Date: Mon, 26 Mar 2018 15:27:02 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ramon Fried <rfried@codeaurora.org> wrote:

> DXE channel defaults used hardcoded magic values.
> Added bit definitions of the control register and
> calculate this values in compilation for clarity.
> 
> Signed-off-by: Ramon Fried <rfried@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

e5d04670904f wcn36xx: calculate DXE default channel values

-- 
https://patchwork.kernel.org/patch/10274693/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

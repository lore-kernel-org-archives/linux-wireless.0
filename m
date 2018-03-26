Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44148 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752088AbeCZP0P (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Mar 2018 11:26:15 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: wcn36xx: calculate DXE control registers values
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180304163134.4464-1-rfried@codeaurora.org>
References: <20180304163134.4464-1-rfried@codeaurora.org>
To: Ramon Fried <rfried@codeaurora.org>
Cc: k.eugene.e@gmail.com, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, Ramon Fried <rfried@codeaurora.org>
Message-Id: <20180326152615.8B4FC60710@smtp.codeaurora.org> (sfid-20180326_172619_603325_F64B047F)
Date: Mon, 26 Mar 2018 15:26:15 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ramon Fried <rfried@codeaurora.org> wrote:

> DXE descriptor control registers used hardcoded magic values.  Added bit
> definitions of the control register and calculate this values in compilation
> for clarity. No functional changes.
> 
> Signed-off-by: Ramon Fried <rfried@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

6ced7958168f wcn36xx: calculate DXE control registers values

-- 
https://patchwork.kernel.org/patch/10257759/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

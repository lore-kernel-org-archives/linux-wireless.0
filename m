Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53541 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbbCUGju (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Mar 2015 02:39:50 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: ath9k: Fix AIC compilation error
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1426859090-10153-1-git-send-email-sujith@msujith.org>
To: Sujith Manoharan <sujith@msujith.org>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Message-Id: <20150321063949.A6F361413D1@smtp.codeaurora.org> (sfid-20150321_073953_491146_E79CE683)
Date: Sat, 21 Mar 2015 06:39:49 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> 
> AIC needs to be registered only when BTCOEX is enabled.
> This fixes the error reported by kbuild:
> 
> >> ERROR: "ar9003_hw_attach_aic_ops" [drivers/net/wireless/ath/ath9k/ath9k_hw.ko] undefined!
> 
> Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo

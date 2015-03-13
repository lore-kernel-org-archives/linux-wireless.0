Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44966 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816AbbCMNUb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2015 09:20:31 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [1/5] ath9k: Add PCIE powersave macros
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1425891010-21522-2-git-send-email-sujith@msujith.org>
To: Sujith Manoharan <sujith@msujith.org>
Cc: linux-wireless@vger.kernel.org
Message-Id: <20150313132030.D4512140D62@smtp.codeaurora.org> (sfid-20150313_142038_522719_41777A2B)
Date: Fri, 13 Mar 2015 13:20:30 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> 
> These will be used to handle chip-specific
> power save configuration.
> 
> Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Thanks, 5 patches applied to wireless-drivers-next.git:

e519f78f1191 ath9k: Add PCIE powersave macros
afa7e6dbd91d ath9k: Fix PLL powersave for AR9485
656cd75c3873 ath9k: Initialize pll_pwrsave for AR9462/AR9565
93f7d6f3d5aa ath9k: Check allowed PCIE powersave configuration
dd2951124838 ath9k: Fix RTT chainmask usage

Kalle Valo

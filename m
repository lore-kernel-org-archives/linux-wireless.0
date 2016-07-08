Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:35310 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692AbcGHGvR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2016 02:51:17 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/2] ath10k: remove unused member in ath10k_hw_regs
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1466488088-20961-1-git-send-email-akolli@qti.qualcomm.com>
To: <akolli@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>,
	Anilkumar Kolli <akolli@qti.qualcomm.com>,
	<akolli@codeaurora.org>, <linux-wireless@vger.kernel.org>
Message-ID: <d4ea57a3ffc1429f9e1a2df3220f54ec@euamsexm01a.eu.qualcomm.com> (sfid-20160708_085120_000394_8DD5B7C1)
Date: Fri, 8 Jul 2016 08:51:10 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

akolli@qti.qualcomm.com wrote:
> From: Anilkumar Kolli <akolli@qti.qualcomm.com>
> 
> rtc_state_cold_reset_mask is unused in ath10k_hw_regs.
> instead fixed delays are used.
> 
> Signed-off-by: Anilkumar Kolli <akolli@qti.qualcomm.com>

Thanks, 2 patches applied to ath-next branch of ath.git:

2225378d840c ath10k: remove unused member in ath10k_hw_regs
e565c3125e03 ath10k: enable support for QCA9888

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9189535/


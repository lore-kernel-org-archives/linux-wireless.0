Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:41668 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933303AbcIBP43 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Sep 2016 11:56:29 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: Added support for extended dbglog module id for 10.4
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1471946736-28214-1-git-send-email-c_mkenna@qti.qualcomm.com>
To: <c_mkenna@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <mkenna@codeaurora.org>,
        <linux-wireless@vger.kernel.org>,
        Maharaja Kennadyrajan <c_mkenna@qti.qualcomm.com>
Message-ID: <7b55a733bcc0414f93030e89e0fb5cbe@euamsexm01a.eu.qualcomm.com> (sfid-20160902_175657_150005_E19F4D49)
Date: Fri, 2 Sep 2016 17:56:21 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

c_mkenna@qti.qualcomm.com wrote:
> From: Maharaja Kennadyrajan <c_mkenna@qti.qualcomm.com>
> 
> For 10.4 fw versions, dbglog module id has been extended from u32
> to u64, hence this patch fixes the same in the ath10k driver side.
> 
> This patch doesn't break the older 10.4 releases. The FW change
> is already present in the older FWs.
> 
> Signed-off-by: Maharaja Kennadyrajan <c_mkenna@qti.qualcomm.com>

Thanks, 1 patch applied to ath-next branch of ath.git:

afcbc82cea52 ath10k: Added support for extended dbglog module id for 10.4

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9295361/

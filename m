Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46526 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727020AbeGaJer (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jul 2018 05:34:47 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH 1/9] ath9k_hw: set spectral scan enable bit on trigger for
 AR9003+
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180723160300.58024-1-nbd@nbd.name>
References: <20180723160300.58024-1-nbd@nbd.name>
To: Felix Fietkau <nbd@nbd.name>
Cc: linux-wireless@vger.kernel.org
Message-Id: <20180731075543.2E14060714@smtp.codeaurora.org> (sfid-20180731_095547_172570_1B14F6B0)
Date: Tue, 31 Jul 2018 07:55:43 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@nbd.name> wrote:

> AR9002 code and the QCA AR9003+ reference code do the same.
> 
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

8 patches applied to ath-next branch of ath.git, thanks.

a2a49e86b325 ath9k_hw: set spectral scan enable bit on trigger for AR9003+
3a69dd366866 ath9k: don't run periodic and nf calibation at the same time
11f7f4f9c0d2 ath9k: fix moredata bit in PS buffered frame release
e20c7c91ef60 ath9k: clear potentially stale EOSP status bit in intermediate queues
36e14a787dd0 ath9k: report tx status on EOSP
1226f9e10296 ath9k: fix block-ack window tracking issues
461d8a6bb987 ath9k_hw: fix channel maximum power level test
52d7e0e5339b ath9k: fix more-data flag for buffered multicast packets

-- 
https://patchwork.kernel.org/patch/10540573/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

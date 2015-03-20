Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51252 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140AbbCTG3L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2015 02:29:11 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [v2,01/11] ath9k: Add initial structures for AIC
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1426312677-2064-2-git-send-email-sujith@msujith.org>
To: Sujith Manoharan <sujith@msujith.org>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Message-Id: <20150320062910.E7EB1140B80@smtp.codeaurora.org> (sfid-20150320_072914_755622_FB0F3246)
Date: Fri, 20 Mar 2015 06:29:10 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> 
> These are necessary for implementing AIC,
> supported by chips like WB222.
> 
> Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Thanks, 11 patches applied to wireless-drivers-next.git:

d3f193ee6538 ath9k: Add initial structures for AIC
637625f2db84 ath9k: Register private AIC ops
6dacafea2d3a ath9k: Add register definitions for AIC
b6ab9ae2eed8 ath9k: Handle MCI_STATE_AIC_CAL_SINGLE
716eed4c0dfb ath9k: Finish AIC calibration
188f1a1288d5 ath9k: Process the AIC calibration results
208837eeb925 ath9k: Disable AIC by default
958b6827b781 ath9k: Handle MCI_STATE_AIC_CAL_RESET
f2ef792a8085 ath9k: Handle MCI_STATE_AIC_START
60544603b669 ath9k: Handle MCI_STATE_AIC_CAL
7644317bd39c ath9k: Start AIC calibration during MCI reset

Kalle Valo

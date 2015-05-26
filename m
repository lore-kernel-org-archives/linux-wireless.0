Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60572 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755526AbbEZOHt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 10:07:49 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: ath9k: split ar5008_hw_spur_mitigate and reuse common code
 inar9002_hw_spur_mitigate.
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1431892159-7563-1-git-send-email-linux@rempel-privat.de>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	nbd@openwrt.org, Oleksij Rempel <linux@rempel-privat.de>
Message-Id: <20150526110317.CFC331417E8@smtp.codeaurora.org> (sfid-20150526_160755_064982_DFC95CDD)
Date: Tue, 26 May 2015 11:03:17 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> [ar5008 and ar9002]_hw_spur_mitigate have big portion of identical code.
> This patch will move common part of ar5008_hw_spur_mitigate to
> ar5008_hw_cmn_spur_mitigate and reuse it in ar9002_hw_spur_mitigate.
> 
> As noticed by Joe Perches I reuse ar9002_hw_spur_mitigate (const) version of
> declarations for pilot_mask_reg and chan_mask_reg.
> 
> There should be no other difference with original code.
> 
> Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo

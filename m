Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51779 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbcDOSFy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Apr 2016 14:05:54 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: ath9k: ar5008_hw_cmn_spur_mitigate: add missing mask_m &
 mask_pinitialisation
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1460482664-21086-1-git-send-email-linux@rempel-privat.de>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	lkml2017@openmailbox.org, Oleksij Rempel <linux@rempel-privat.de>
Message-Id: <20160415180553.67DF3601B5@smtp.codeaurora.org> (sfid-20160415_200558_216223_D5F6DD69)
Date: Fri, 15 Apr 2016 18:05:53 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> by moving common code to ar5008_hw_cmn_spur_mitigate i forgot to move
> mask_m & mask_p initialisation. This coused a performance regression
> on ar9281.
> 
> Fixes: f911085ffa88 ("ath9k: split ar5008_hw_spur_mitigate and reuse common code in ar9002_hw_spur_mitigate.")
> Reported-by: Gustav Frederiksen <lkml2017@openmailbox.org>
> Tested-by: Gustav Frederiksen <lkml2017@openmailbox.org>
> Cc: <stable@vger.kernel.org> # 4.2+
> Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>

Thanks, applied to wireless-drivers.git.

Kalle Valo

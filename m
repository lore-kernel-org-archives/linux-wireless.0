Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40063 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbbECUy5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 May 2015 16:54:57 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: ath9k: fix per-packet tx power configuration
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1428519117-15833-1-git-send-email-lorenzo.bianconi83@gmail.com>
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Cc: linux-wireless@vger.kernel.org, nbd@openwrt.org
Message-Id: <20150503205456.9B2F2140112@smtp.codeaurora.org> (sfid-20150503_225500_510673_201F42B3)
Date: Sun,  3 May 2015 20:54:56 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Do not use ieee80211_vif pointer in ath_get_rate_txpower() since it has been
> overwritten by setup_frame_info() and it will result in a corrupted tx power
> configuration. Set per-packet tx power in setup_frame_info() according to
> current vif tx power.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>

Thanks, applied to wireless-drivers.git.

Kalle Valo

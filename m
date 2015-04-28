Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53139 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965801AbbD1Pwy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Apr 2015 11:52:54 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Cc: linux-wireless@vger.kernel.org, nbd@openwrt.org
Subject: Re: [PATCH] ath9k: fix per-packet tx power configuration
References: <1428519117-15833-1-git-send-email-lorenzo.bianconi83@gmail.com>
Date: Tue, 28 Apr 2015 18:52:47 +0300
In-Reply-To: <1428519117-15833-1-git-send-email-lorenzo.bianconi83@gmail.com>
	(Lorenzo Bianconi's message of "Wed, 8 Apr 2015 20:51:57 +0200")
Message-ID: <87r3r45jxs.fsf@kamboji.qca.qualcomm.com> (sfid-20150428_175257_990531_BD44A699)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lorenzo Bianconi <lorenzo.bianconi83@gmail.com> writes:

> Do not use ieee80211_vif pointer in ath_get_rate_txpower() since it has been
> overwritten by setup_frame_info() and it will result in a corrupted tx power
> configuration. Set per-packet tx power in setup_frame_info() according to
> current vif tx power.
>
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>

I'm planning to send this fix to 4.1, is that ok?

-- 
Kalle Valo

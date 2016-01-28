Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42352 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966563AbcA1I1a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jan 2016 03:27:30 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: miaoqing@codeaurora.org
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@qca.qualcomm.com, nbd@openwrt.org
Subject: Re: [PATCH v3 0/5] ath9k bug fixes
References: <1453080830-7616-1-git-send-email-miaoqing@codeaurora.org>
Date: Thu, 28 Jan 2016 10:27:24 +0200
In-Reply-To: <1453080830-7616-1-git-send-email-miaoqing@codeaurora.org>
	(miaoqing@codeaurora.org's message of "Mon, 18 Jan 2016 09:33:45
	+0800")
Message-ID: <877fium7mb.fsf@kamboji.qca.qualcomm.com> (sfid-20160128_092735_972209_136FDE25)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

miaoqing@codeaurora.org writes:

> From: Miaoqing Pan <miaoqing@codeaurora.org>
>
> ath9k bug fixes
>
> Miaoqing Pan (5):
>   ath9k: avoid ANI restart if no trigger
>   ath9k: clean up ANI per-channel pointer checking
>   ath9k: do not reset while BB panic(0x4000409) on ar9561
>   ath9k: fix inconsistent use of tab and space in indentation
>   ath9k: fix data bus error on ar9300 and ar9580

All applied to ath.git, thanks.

-- 
Kalle Valo

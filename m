Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33075 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbbHGIVc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2015 04:21:32 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: ath9k: fix build with CONFIG_ATH9K_STATION_STATISTICS=y
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1438857870-18580-1-git-send-email-nbd@openwrt.org>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Message-Id: <20150807082131.5C0881401BE@smtp.codeaurora.org> (sfid-20150807_102138_783797_3664AE29)
Date: Fri,  7 Aug 2015 08:21:31 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> kbuild bot reported that commit 592fa228f213 ("ath9k: remove struct
> ath_atx_ac") broke the build when CONFIG_ATH9K_STATION_STATISTICS is y.
> 
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Fixes: 592fa228f213 ("ath9k: remove struct ath_atx_ac")
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo

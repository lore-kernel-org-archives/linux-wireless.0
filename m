Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:4517 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbcGHGlb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2016 02:41:31 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v4,1/2] ath10k: Add support for ath10k_sta_statistics support
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1465890866-2390-1-git-send-email-mohammed@qca.qualcomm.com>
To: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <mohammed@codeaurora.org>,
	<linux-wireless@vger.kernel.org>,
	Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
Message-ID: <8a33ff29139b4261936f5d7a5c0d9865@euamsexm01a.eu.qualcomm.com> (sfid-20160708_084135_281089_4439AA27)
Date: Fri, 8 Jul 2016 08:40:29 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com> wrote:
> From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> 
> Enable support for 'drv_sta_statistics' callback.
> Export rx_duration support if available to cfg80211/nl80211
> 
> This can also act as a placeholder for any new per STA stats support
> 
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

Thanks, 2 patches applied to ath-next branch of ath.git:

120a1f02a5c4 ath10k: add support for ath10k_sta_statistics support
2ba1f3709452 ath10k: remove debugfs support for Per STA total rx duration

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9175135/


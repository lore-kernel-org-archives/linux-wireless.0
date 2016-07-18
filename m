Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40555 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099AbcGRTj6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jul 2016 15:39:58 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [-next] mwifiex: fix possible memory leak in
 mwifiex_cfg80211_start_ap()
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1468323798-6075-1-git-send-email-weiyj_lk@163.com>
To: weiyj_lk@163.com
Cc: Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
	linux-wireless@vger.kernel.org
Message-Id: <20160718193957.DA1676034D@smtp.codeaurora.org> (sfid-20160718_214020_977757_989BE7DB)
Date: Mon, 18 Jul 2016 19:39:57 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

weiyj_lk@163.com wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> memory is malloced in mwifiex_cfg80211_start_ap() and should be
> freed before leaving from the error handling cases, otherwise it
> will cause memory leak.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Thanks, 1 patch applied to wireless-drivers-next.git:

4028a514eaa6 mwifiex: fix possible memory leak in mwifiex_cfg80211_start_ap()

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9225159/


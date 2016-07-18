Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40519 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbcGRTjb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jul 2016 15:39:31 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [-next] libertas: fix non static symbol warning
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1468323139-1756-1-git-send-email-weiyj_lk@163.com>
To: weiyj_lk@163.com
Cc: sudip <sudipm.mukherjee@gmail.com>,
	Andreas Kemnade <andreas@kemnade.info>,
	Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
	libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Message-Id: <20160718193930.556206043B@smtp.codeaurora.org> (sfid-20160718_213934_481844_D2AD0A00)
Date: Mon, 18 Jul 2016 19:39:30 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

weiyj_lk@163.com wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Fixes the following sparse warning:
> 
> drivers/net/wireless/marvell/libertas/cfg.c:2047:5: warning:
>  symbol 'lbs_set_power_mgmt' was not declared. Should it be static?
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Thanks, 1 patch applied to wireless-drivers-next.git:

83d58d53e062 libertas: fix non static symbol warning

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9225147/


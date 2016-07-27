Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40000 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754295AbcG0OIF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jul 2016 10:08:05 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: weiyj_lk@163.com
Cc: Kalle Valo <kvalo@codeaurora.org>,
	Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH -next] rtl8xxxu: gen1: Fix non static symbol warning
References: <1468334014-9098-1-git-send-email-weiyj_lk@163.com>
Date: Wed, 27 Jul 2016 10:08:03 -0400
In-Reply-To: <1468334014-9098-1-git-send-email-weiyj_lk@163.com> (weiyj lk's
	message of "Tue, 12 Jul 2016 14:33:34 +0000")
Message-ID: <wrfj37mv6unw.fsf@redhat.com> (sfid-20160727_160814_202132_EED1FB26)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

weiyj_lk@163.com writes:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Fixes the following sparse warning:
>
> drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c:898:1: warning:
>  symbol 'rtl8xxxu_gen1_h2c_cmd' was not declared. Should it be static?
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Looks reasonable - I'll apply it to my tree.

Thanks,
Jes

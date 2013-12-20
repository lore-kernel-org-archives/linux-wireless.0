Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:45508 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab3LTDSz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Dec 2013 22:18:55 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21171.46575.135931.15393@gargle.gargle.HOWL> (sfid-20131220_041859_541326_C99B4D31)
Date: Fri, 20 Dec 2013 08:43:51 +0530
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: <ath9k-devel@qca.qualcomm.com>, <linville@tuxdriver.com>,
	<yongjun_wei@trendmicro.com.cn>, <linux-wireless@vger.kernel.org>,
	<ath9k-devel@lists.ath9k.org>
Subject: Re: [PATCH -next] ath9k: fix sparse non static symbol warning
In-Reply-To: <CAPgLHd8Cn-UkVp1VMpAuR2w64-3BgxfHCqnqo3bjGGYtW0-RwQ@mail.gmail.com>
References: <CAPgLHd8Cn-UkVp1VMpAuR2w64-3BgxfHCqnqo3bjGGYtW0-RwQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Fixes the following sparse warning:
> 
> drivers/net/wireless/ath/ath9k/spectral.c:500:24: warning:
>  symbol 'rfs_spec_scan_cb' was not declared. Should it be static?

Thanks. This was also reported by the 0-day kbuild test.

Sujith

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:41916 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706Ab2KPSTl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2012 13:19:41 -0500
Message-ID: <1353089926.10872.78.camel@cumari.coelho.fi> (sfid-20121116_191944_081224_B422BBEB)
Subject: Re: [PATCH] wlcore: spi: use platform_device_unregister in
 wl1271_remove()
From: Luciano Coelho <coelho@ti.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
CC: <linville@tuxdriver.com>, <yongjun_wei@trendmicro.com.cn>,
	<linux-wireless@vger.kernel.org>
Date: Fri, 16 Nov 2012 20:18:46 +0200
In-Reply-To: <CAPgLHd_nBOfMzHuL3GtwOjsV3+jKMdCxL+cJr9xT0-0fBGabrQ@mail.gmail.com>
References: <CAPgLHd_nBOfMzHuL3GtwOjsV3+jKMdCxL+cJr9xT0-0fBGabrQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-10-23 at 13:22 +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> platform_device_unregister() only calls platform_device_del() and
> platform_device_put(), thus use platform_device_unregister() to
> simplify the code.
> 
> Also the documents in platform.c shows that platform_device_del
> and platform_device_put must _only_ be externally called in error
> cases.  All other usage is a bug.
> 
> dpatch engine is used to auto generate this patch.
> (https://github.com/weiyj/dpatch)
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---

Applied, thanks!

--
Luca.


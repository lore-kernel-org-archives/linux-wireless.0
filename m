Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:54580 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758445Ab2HXRax (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Aug 2012 13:30:53 -0400
Date: Fri, 24 Aug 2012 13:30:50 -0400 (EDT)
Message-Id: <20120824.133050.95947607393326346.davem@davemloft.net> (sfid-20120824_193057_998808_6193F2DC)
To: weiyj.lk@gmail.com
Cc: j@w1.fi, linville@tuxdriver.com, yongjun_wei@trendmicro.com.cn,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] drivers/net: use is_zero_ether_addr() instead of
 memcmp()
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAPgLHd_L1=1zaq=NUAjr+3822WfR2gV-sMA2tzKowHEezPmvOA@mail.gmail.com>
References: <CAPgLHd_L1=1zaq=NUAjr+3822WfR2gV-sMA2tzKowHEezPmvOA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wei Yongjun <weiyj.lk@gmail.com>
Date: Thu, 23 Aug 2012 15:16:44 +0800

> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Using is_zero_ether_addr() instead of directly use
> memcmp() to determine if the ethernet address is all
> zeros.
> 
> spatch with a semantic match is used to found this problem.
> (http://coccinelle.lip6.fr/)
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Since this is wireless, John will pick it up.

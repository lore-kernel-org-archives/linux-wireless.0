Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog137.obsmtp.com ([74.125.149.18]:38880 "EHLO
	na3sys009aog137.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750924Ab2HXDdO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Aug 2012 23:33:14 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"yongjun_wei@trendmicro.com.cn" <yongjun_wei@trendmicro.com.cn>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date: Thu, 23 Aug 2012 20:30:54 -0700
Subject: RE: [PATCH] mwifiex: use is_zero_ether_addr() instead of memcmp()
Message-ID: <477F20668A386D41ADCC57781B1F7043083B0BBB71@SC-VEXCH1.marvell.com> (sfid-20120824_053323_307135_0D68A088)
References: <CAPgLHd--KY+zNjUwOHKgEJuTfJuoA=7vKR3JMBUgUc+BtjC9Ng@mail.gmail.com>
In-Reply-To: <CAPgLHd--KY+zNjUwOHKgEJuTfJuoA=7vKR3JMBUgUc+BtjC9Ng@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > Apparently there are two more occurrences of zero_mac (scan.c:843)
> 
> This is part is special:
> 
> memcmp(scan_cfg_out->specific_bssid, &zero_mac, sizeof(zero_mac)))
> 
> &zero_mac equal zero_mac, but it missing to spatch.

I will take care of this then.

Thanks,
Bing


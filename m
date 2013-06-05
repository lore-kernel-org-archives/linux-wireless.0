Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28321 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752500Ab3FEILo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 04:11:44 -0400
Date: Wed, 5 Jun 2013 10:13:35 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: linville@tuxdriver.com, yongjun_wei@trendmicro.com.cn,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] iwlegacy: fix error return code in il3945_pci_probe()
Message-ID: <20130605081334.GB1510@redhat.com> (sfid-20130605_101153_596897_200A682F)
References: <CAPgLHd8XdFPQ+HUq085qmge66dhMxJurrZ2Uwut4w6Pfh_sqhA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAPgLHd8XdFPQ+HUq085qmge66dhMxJurrZ2Uwut4w6Pfh_sqhA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 05, 2013 at 10:16:33AM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Fix to return a negative error code in the il3945_hw_set_hw_params() error
> handling case instead of 0, as done elsewhere in this function.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>

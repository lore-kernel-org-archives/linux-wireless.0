Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57908 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343AbbC3IeI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 04:34:08 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: mwifiex: remove an unneede NULL check in mwifiex_init_adapter()
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20150323093551.GC558@mwanda>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Message-Id: <20150330083407.C034F140243@smtp.codeaurora.org> (sfid-20150330_103416_630980_22879573)
Date: Mon, 30 Mar 2015 08:34:07 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> "adapter->sleep_cfm" is always non-NULL at this point.  Static checkers
> complain that we already dereference it at the start of the function
> when we do:
> 
> 	skb_put(adapter->sleep_cfm, sizeof(struct mwifiex_opt_sleep_confirm));
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> Acked-by: Amitkumar Karwar <akarwar@marvell.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo

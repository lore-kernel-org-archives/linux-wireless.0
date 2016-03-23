Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51894 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932218AbcCWPv6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Mar 2016 11:51:58 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: b43: Fix memory leaks in b43_bus_dev_ssb_init
 andb43_bus_dev_bcma_init
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1457716477-6287-1-git-send-email-sudipm.mukherjee@gmail.com>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	b43-dev@lists.infradead.org, netdev@vger.kernel.org,
	Jia-Ju Bai <baijiaju1990@163.com>,
	=?UTF-8?q?Michael=20B=C3=BCsch?= <m@bues.ch>
Message-Id: <20160323155157.B5F0A615D8@smtp.codeaurora.org> (sfid-20160323_165220_870118_9A57E0DF)
Date: Wed, 23 Mar 2016 15:51:57 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Jia-Ju Bai <baijiaju1990@163.com>
> 
> The memory allocated by kzalloc in b43_bus_dev_ssb_init and
> b43_bus_dev_bcma_init is not freed.
> This patch fixes the bug by adding kfree in b43_ssb_remove,
> b43_bcma_remove and error handling code of b43_bcma_probe.
> 
> Thanks Michael for his suggestion.
> 
> Signed-off-by: Jia-Ju Bai <baijiaju1990@163.com>
> Acked-by: Michael Büsch <m@bues.ch>
> Signed-off-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

Thanks, applied to wireless-drivers.git.

Kalle Valo

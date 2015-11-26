Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40869 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806AbbKZMGE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2015 07:06:04 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: ath9k_htc: check for underflow in ath9k_htc_rx_msg()
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20151106100120.GB18557@mwanda>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
	kernel-janitors@vger.kernel.org
Message-Id: <20151126120550.4AF5413F351@smtp.codeaurora.org> (sfid-20151126_130610_036789_B792D778)
Date: Thu, 26 Nov 2015 12:05:50 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> We check for overflow here, but we don't check for underflow so it
> causes a static checker warning.
> 
> Fixes: fb9987d0f748 ('ath9k_htc: Support for AR9271 chipset.')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo

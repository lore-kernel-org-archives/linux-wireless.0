Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50504 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167AbbHFHGL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2015 03:06:11 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: mwifiex: sdio: reset adapter using mmc_hw_reset
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1437065401-20245-1-git-send-email-afenkart@gmail.com>
To: Andreas Fenkart <afenkart@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Andreas Fenkart <afenkart@gmail.com>
Message-Id: <20150806070612.242A2141E99@smtp.codeaurora.org> (sfid-20150806_090618_333752_D51CDDD1)
Date: Thu,  6 Aug 2015 07:06:12 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Since 1fb654fd97ff("mmc: sdio: add reset callback to bus operations"),
> sdio cards can be power cycled using mmc_hw_reset.
> The use mmc_remove_host/mmc_add_host is discouraged, because these are
> internal functions to the mmc core and should only be used by mmc hosts
> 
> Signed-off-by: Andreas Fenkart <afenkart@gmail.com>
> Acked-by: Amitkumar Karwar <akarwar@marvell.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo

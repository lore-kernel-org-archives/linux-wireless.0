Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41650 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725AbcA2JPV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jan 2016 04:15:21 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: wlcore: fix error handling in wlcore_event_fw_logger
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1452173330-19963-1-git-send-email-a.hajda@samsung.com>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: Shahar Patury <shaharp@ti.com>,
	linux-wireless@vger.kernel.org (open list:TI WILINK WIRELESS DRIVERS),
	Andrzej Hajda <a.hajda@samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
	linux-kernel@vger.kernel.org (open list)
Message-Id: <20160129091520.9A0D76045B@smtp.codeaurora.org> (sfid-20160129_101739_838890_BFA9EE8C)
Date: Fri, 29 Jan 2016 09:15:20 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> wlcore_read/wlcore_write can return negative values so it should
> be assigned to signed variable.
> 
> The problem has been detected using proposed semantic patch
> scripts/coccinelle/tests/unsigned_lesser_than_zero.cocci [1].
> 
> [1]: http://permalink.gmane.org/gmane.linux.kernel/2120705
> 
> Fixes: 3719c17e1816 ("wlcore/wl18xx: fw logger over sdio")
> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo

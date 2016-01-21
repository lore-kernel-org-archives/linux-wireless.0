Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55957 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759002AbcAUNww (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2016 08:52:52 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Guy Mishol <guym@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] wlcore: fix return value of wlcore_event_fw_logger
References: <1453109702-15750-1-git-send-email-guym@ti.com>
Date: Thu, 21 Jan 2016 15:52:47 +0200
In-Reply-To: <1453109702-15750-1-git-send-email-guym@ti.com> (Guy Mishol's
	message of "Mon, 18 Jan 2016 11:35:02 +0200")
Message-ID: <8760ynyr80.fsf@kamboji.qca.qualcomm.com> (sfid-20160121_145255_773465_E13CCF91)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Guy Mishol <guym@ti.com> writes:

> The function can return negative values in case of error.
> Fixes: 3719c17e1816 ("wlcore/wl18xx: fw logger over sdio")
>
> Signed-off-by: Guy Mishol <guym@ti.com>

Andrzej already submitted identical patch:

https://patchwork.kernel.org/patch/7977461/

So I'm dropping this.

-- 
Kalle Valo

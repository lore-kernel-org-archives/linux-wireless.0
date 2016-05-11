Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60194 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932109AbcEKSPu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 May 2016 14:15:50 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Guy Mishol <guym@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] wlcore/wl12xx: Fix fw logger over sdio
References: <1460624297-28420-1-git-send-email-guym@ti.com>
Date: Wed, 11 May 2016 21:15:45 +0300
In-Reply-To: <1460624297-28420-1-git-send-email-guym@ti.com> (Guy Mishol's
	message of "Thu, 14 Apr 2016 11:58:17 +0300")
Message-ID: <87h9e4ea0e.fsf@kamboji.qca.qualcomm.com> (sfid-20160511_201554_058436_0ABB2DE1)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Guy Mishol <guym@ti.com> writes:

> The commit fb724ed5c617 ("wlcore: Fix regression in
> wlcore_set_partition()") fixed wl12xx functionality.
> However, it reverted the support in fw logger
> over sdio in wl18xx.
>
> This patch reverts the changes made and also fixes
> the original functionality issue introduced in wl12xx.
>
> Fixes: fb724ed5c617
> ("wlcore: Fix regression in wlcore_set_partition()")
>
> Signed-off-by: Guy Mishol <guym@ti.com>

Fixes in one line, no line wrapping please. Also no empty line between
Fixes and S-o-b lines. I'll fix these this time.

-- 
Kalle Valo

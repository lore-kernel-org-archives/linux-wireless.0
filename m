Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:32879 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692AbcEKS04 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 May 2016 14:26:56 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: wlcore/wl12xx: Fix fw logger over sdio
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1460624297-28420-1-git-send-email-guym@ti.com>
To: Guy Mishol <guym@ti.com>
Cc: <linux-wireless@vger.kernel.org>, Guy Mishol <guym@ti.com>
Message-Id: <20160511182655.C83A6601B5@smtp.codeaurora.org> (sfid-20160511_202659_684195_F93483B8)
Date: Wed, 11 May 2016 18:26:55 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Guy Mishol <guym@ti.com> wrote:
> The commit fb724ed5c617 ("wlcore: Fix regression in
> wlcore_set_partition()") fixed wl12xx functionality.
> However, it reverted the support in fw logger
> over sdio in wl18xx.
> 
> This patch reverts the changes made and also fixes
> the original functionality issue introduced in wl12xx.
> 
> Fixes: fb724ed5c617 ("wlcore: Fix regression in wlcore_set_partition()")
> Signed-off-by: Guy Mishol <guym@ti.com>

Thanks, 1 patch applied to wireless-drivers-next.git:

6fe813e3d561 wlcore/wl12xx: Fix fw logger over sdio

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/8833001/


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35160 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbbLaIUj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Dec 2015 03:20:39 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: wlcore/wl18xx: fw logger over sdio
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1450787406-22152-1-git-send-email-guym@ti.com>
To: Guy Mishol <guym@ti.com>
Cc: <linux-wireless@vger.kernel.org>, Shahar Patury <shaharp@ti.com>,
	Guy Mishol <guym@ti.com>
Message-Id: <20151231082038.E8BA160217@smtp.codeaurora.org> (sfid-20151231_092042_170331_C6326B69)
Date: Thu, 31 Dec 2015 08:20:38 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Shahar Patury <shaharp@ti.com>
> 
> Enable the FW Logger to work over the SDIO interface in addition to over UART
> interface. In the new design we use fw internal memory instead of packet ram
> that was used in older (wl12xx) design. This change reduces the impact on TP
> and stability.
> 
> A new event was added to notify fw logger is ready for reading. Dynamic
> configuration to debugfs was added as well.
> 
> Signed-off-by: Shahar Patury <shaharp@ti.com>
> Signed-off-by: Guy Mishol <guym@ti.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo

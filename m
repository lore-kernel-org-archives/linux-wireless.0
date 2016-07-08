Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40135 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932412AbcGHKAZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2016 06:00:25 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] wlcore: time sync : add support for 64 bit clock
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20160627133744.12564-1-yanivma@ti.com>
To: "Machani, Yaniv" <yanivma@ti.com>
Cc: <linux-kernel@vger.kernel.org>, Yaniv Machani <yanivma@ti.com>,
	Guy Mishol <guym@ti.com>, Eliad Peller <eliad@wizery.com>,
	Johannes Berg <johannes.berg@intel.com>,
	<linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>
Message-Id: <20160708100024.7950A611E2@smtp.codeaurora.org> (sfid-20160708_120056_870943_341124CA)
Date: Fri,  8 Jul 2016 10:00:24 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Machani, Yaniv" <yanivma@ti.com> wrote:
> Changed the configuration to support 64bit instead of 32bit
> this in order to offload the driver from handling a wraparound.
> 
> Signed-off-by: Yaniv Machani <yanivma@ti.com>

Thanks, 1 patch applied to wireless-drivers-next.git:

585dfe813fa5 wlcore: time sync : add support for 64 bit clock

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9200631/


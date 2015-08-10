Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60805 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755060AbbHJTSl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2015 15:18:41 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [1/4] wlcore/wl18xx : add time sync event handling
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1438285102-32751-1-git-send-email-yanivma@ti.com>
To: "Machani, Yaniv" <yanivma@ti.com>
Cc: <linux-wireless@vger.kernel.org>, <yanivma@ti.com>
Message-Id: <20150810191840.63FDA141174@smtp.codeaurora.org> (sfid-20150810_211846_452063_01ED583D)
Date: Mon, 10 Aug 2015 19:18:40 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Added support for a new time sync event
> the event data contains the WiLink TSF value.
> To trigger the event, a HW modification is required,
> so as a supporting firmware binary.
> 
> Signed-off-by: Yaniv Machani <yanivma@ti.com>

Thanks, 4 patches applied to wireless-drivers-next.git:

6d5c898798ac wlcore/wl18xx : add time sync event handling
8698a3a4fff2 wl18xx: use long intervals in sched scan
c32e35f29ce9 wlcore: add generic_cfg_feature command definitions
7845af35e0de wlcore: add p2p device support

Kalle Valo

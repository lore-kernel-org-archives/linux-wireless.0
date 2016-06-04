Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39804 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbcFDO6h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Jun 2016 10:58:37 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [v2] carl9170: Clarify kconfig text
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20160416171856.1769c0e16bcc75372407e06f@gmx.com>
To: Lauri Kasanen <cand@gmx.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Message-Id: <20160604145835.EE22A613CF@smtp.codeaurora.org> (sfid-20160604_165906_768810_32714B2B)
Date: Sat,  4 Jun 2016 14:58:35 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lauri Kasanen <cand@gmx.com> wrote:
> The previous text was confusing, leading readers to think this
> driver was a duplicate, and so didn't need to be enabled.
> 
> After the removal of the older staging driver, this is the only
> driver in mainline for these devices.
> 
> Signed-off-by: Lauri Kasanen <cand@gmx.com>
> Acked-by: Christian Lamparter <chunkeey@googlemail.com>

Thanks, 1 patch applied to wireless-drivers-next.git:

83e41e77819b carl9170: Clarify kconfig text

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/8861621/


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51758 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179AbbHFHRg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2015 03:17:36 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [1/4] mwifiex: using right aid value for tdls action frame
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1437566025-3324-1-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
	Xinming Hu <huxm@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <20150806071736.C45FE14200B@smtp.codeaurora.org> (sfid-20150806_091740_187481_105234B3)
Date: Thu,  6 Aug 2015 07:17:36 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Xinming Hu <huxm@marvell.com>
> 
> Variable pos is u8 here, so memcpy is needed to store u16 aid.
> At the same time, aid should be platform independent, upper layer
> utility(wpa_supplicant,etc.,) parse it as le16, so keep it le16
> here.
> 
> Signed-off-by: Xinming Hu <huxm@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

Thanks, 4 patches applied to wireless-drivers-next.git:

3afafd6dcc0c mwifiex: using right aid value for tdls action frame
398750992ebe mwifiex: fix command timeout for PCIe chipsets
d788ac29793a mwifiex: fix system crash observed during initialisation
2728cecdc7d6 mwifiex: corrections in PCIe event skb handling

Kalle Valo

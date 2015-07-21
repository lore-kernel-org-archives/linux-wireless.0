Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57820 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808AbbGUNl5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jul 2015 09:41:57 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [01/17] mwifiex: add tx data pause support
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1434980183-2901-2-git-send-email-patila@marvell.com>
To: Avinash Patil <patila@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, <akarwar@marvell.com>,
	<cluo@marvell.com>, <huxm@marvell.com>,
	Avinash Patil <patila@marvell.com>
Message-Id: <20150721134157.1D27F14103F@smtp.codeaurora.org> (sfid-20150721_154636_961544_ADE67F65)
Date: Tue, 21 Jul 2015 13:41:57 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> This patch adds support to enable TX data pause feature for mwifiex.
> Whenever FW TX buffers reach threshold, FW would send TX pause event
> to driver. Driver in turn would block data traffic to that particular
> receiver address.
> 
> Signed-off-by: Avinash Patil <patila@marvell.com>
> Signed-off-by: Xinming Hu <huxm@marvell.com>
> Signed-off-by: Cathy Luo <cluo@marvell.com>

Thanks, 17 patches applied to wireless-drivers-next.git:

4e6ee91bb728 mwifiex: add tx data pause support
b5b0f272d618 mwifiex: block data traffic to tx paused receive address
9186a1f37d19 mwifiex: do not increase tx_pkts_queued if receive address tx paused
ba101ad50a50 mwifiex: add tdls channel switch status
f7669877e7ab mwifiex: process tdls channel switch event
449b8bbf45e6 mwifiex: add tdls config command
20834343a8e6 mwifiex: enable tdls channel switch ext_cap
55a2c0770634 mwifiex: enhance tdls link setup condition
b04975970676 mwifiex: add cfg80211 tdls channel switch handler
65d48e597106 mwifiex: update domain_info upon band change in start_ap
a1777327126e mwifiex: support for bypass tx queue
5c8946330abf mwifiex: enable traffic only when port is open
ddd7ceb3f6dd mwifiex: extend tx_data pause to AP interface as well
d5b036c403f8 mwifiex: support to set multichannel policy to FW
de9e9932b76d mwifiex: advertise multichannel support to cfg80211
cc7359b5c82f mwifiex: separate interface combination for multichannel and DFS
8d6b538a5eac mwifiex: handle multichannel event

Kalle Valo

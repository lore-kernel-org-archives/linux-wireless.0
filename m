Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34764 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303AbbB0INJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Feb 2015 03:13:09 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: mwifiex: DMA alignment for RX packets
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1423829468-9460-1-git-send-email-patila@marvell.com>
To: Avinash Patil <patila@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, <akarwar@marvell.com>,
	<cluo@marvell.com>, <gaoqs@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Marc Yang <yangyang@marvell.com>
Message-Id: <20150227081308.EB48213FF13@smtp.codeaurora.org> (sfid-20150227_091313_984561_05D513AC)
Date: Fri, 27 Feb 2015 08:13:08 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> This patch adds support for DMA alignment of sk_buffs
> allocated for RX.
> Patch also adds support to modify skb allocation flags.
> 
> Signed-off-by: Marc Yang <yangyang@marvell.com>
> Signed-off-by: Qingshui Gao <gaoqs@marvell.com>
> Signed-off-by: Cathy Luo <cluo@marvell.com>
> Signed-off-by: Avinash Patil <patila@marvell.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51900 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978AbbHFHTu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2015 03:19:50 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: mwifiex: add missing skb_push() in mwifiex_check_uap_capabilties
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1437998547-3592-1-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>
Message-Id: <20150806071950.76CC1142033@smtp.codeaurora.org> (sfid-20150806_091952_926564_2E116031)
Date: Thu,  6 Aug 2015 07:19:50 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> For PCIe/USB chipsets, preallocated skb buffers are reused for
> event handling. mwifiex_check_uap_capabilties() performs
> skb_pull(). This patch adds missing skb_push() to restore skb's
> data pointer/length.
> 
> This bug was introduced by commit debfc6008169 ("mwifiex: update
> AP WMM settings from BSS_START event")
> 
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo

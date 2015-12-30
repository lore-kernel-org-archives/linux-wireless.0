Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38808 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbbL3PCf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Dec 2015 10:02:35 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Shengzhen Li <szli@marvell.com>
Subject: Re: [PATCH 02/14] mwifiex: multiple bss support
References: <1450095315-19927-1-git-send-email-akarwar@marvell.com>
	<1450095315-19927-3-git-send-email-akarwar@marvell.com>
Date: Wed, 30 Dec 2015 17:02:27 +0200
In-Reply-To: <1450095315-19927-3-git-send-email-akarwar@marvell.com>
	(Amitkumar Karwar's message of "Mon, 14 Dec 2015 04:15:03 -0800")
Message-ID: <87fuykou7w.fsf@kamboji.qca.qualcomm.com> (sfid-20151230_160237_447571_0A2258F4)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com> writes:

> From: Shengzhen Li <szli@marvell.com>
>
> This patch fixes issues observed while starting 3 different
> bss simultaneously, eg, 2 AP + 1 STA or 3 AP
>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

I applied this already but I want to point out still that the title is
quite vague. For example, "mwifiex: fix an issue with 3 simultaneous
bss" would have been more informative.

-- 
Kalle Valo

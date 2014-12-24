Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:55923 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbaLXRKI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Dec 2014 12:10:08 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Avinash Patil <patila@marvell.com>
Cc: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	<akarwar@marvell.com>, <cluo@marvell.com>, <yangyang@marvell.com>,
	Xinming Hu <huxm@marvell.com>
Subject: Re: [PATCH v2 3/4] mwifiex: make tx packet 64 byte DMA aligned
References: <1418903926-11859-1-git-send-email-patila@marvell.com>
	<1418903926-11859-3-git-send-email-patila@marvell.com>
Date: Wed, 24 Dec 2014 19:10:02 +0200
In-Reply-To: <1418903926-11859-3-git-send-email-patila@marvell.com> (Avinash
	Patil's message of "Thu, 18 Dec 2014 17:28:45 +0530")
Message-ID: <87y4px6kk5.fsf@kamboji.qca.qualcomm.com> (sfid-20141224_181012_723202_1C034840)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Avinash Patil <patila@marvell.com> writes:

> From: Xinming Hu <huxm@marvell.com>
>
> This patch adds support for DMA alignment of 64 bytes for TX packets.
>
> v2: incorporate review comments from Joe - define pad as unsigned int;
>     remove magic numbers from definition of MWIFIEX_MIN_DATA_HEADER_LEN
>
> Signed-off-by: Xinming Hu <huxm@marvell.com>
> Signed-off-by: Avinash Patil <patila@marvell.com>

Same problem here, changelog in the commit log.

-- 
Kalle Valo

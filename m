Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:62700 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279AbbA2M26 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jan 2015 07:28:58 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] ath10k: change dma beacon cmd prototype
References: <1421412811-6387-1-git-send-email-michal.kazior@tieto.com>
	<1422440525-11115-1-git-send-email-michal.kazior@tieto.com>
Date: Thu, 29 Jan 2015 14:28:46 +0200
In-Reply-To: <1422440525-11115-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Wed, 28 Jan 2015 11:22:04 +0100")
Message-ID: <87zj9122kh.fsf@kamboji.qca.qualcomm.com> (sfid-20150129_132901_424192_BDDEE8E3)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> The command logic shouldn't really care about
> arvif structure.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

There was a conflict but 3-way merge automatically solved. Please check
the result any in the pending branch.

-- 
Kalle Valo

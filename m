Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:8945 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754857AbbKDR3l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2015 12:29:41 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <manikanta.pubbisetty@gmail.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCHv2] ath10k: consolidate if statements in ath10k_wmi_event_mgmt_rx
References: <1445323300-17431-1-git-send-email-manikanta.pubbisetty@gmail.com>
Date: Wed, 4 Nov 2015 19:29:23 +0200
In-Reply-To: <1445323300-17431-1-git-send-email-manikanta.pubbisetty@gmail.com>
	(manikanta pubbisetty's message of "Tue, 20 Oct 2015 12:11:40 +0530")
Message-ID: <87fv0ld66k.fsf@kamboji.qca.qualcomm.com> (sfid-20151104_182944_652059_65F70D7C)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

manikanta.pubbisetty@gmail.com writes:

> From: Manikanta Pubbisetty <manikanta.pubbisetty@gmail.com>
>
> This patch replaces mutliple if conditional checks with a single if condition
> in WMI management rx handler. Found during code review.
>
> Signed-off-by: Manikanta Pubbisetty <manikanta.pubbisetty@gmail.com>

Applied, thanks.

-- 
Kalle Valo

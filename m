Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:46809 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784Ab3H1EJS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Aug 2013 00:09:18 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: Fix mutex unlock balance
References: <1377102404-14742-1-git-send-email-mohammed@qca.qualcomm.com>
Date: Wed, 28 Aug 2013 07:09:12 +0300
In-Reply-To: <1377102404-14742-1-git-send-email-mohammed@qca.qualcomm.com>
	(Mohammed Shafi Shajakhan's message of "Wed, 21 Aug 2013 21:56:44
	+0530")
Message-ID: <8738pulamv.fsf@kamboji.qca.qualcomm.com> (sfid-20130828_060921_767579_4715D7A9)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com> writes:

> From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
>
> ath10k_debug_read_target_stats is properly
> protected by data_lock (spinlock). Remove
> the unwanted mutex_unlock(&ar->conf_mutex)

[...]

>
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

Thanks, applied.

-- 
Kalle Valo

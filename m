Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:53818 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779AbbLHOyQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2015 09:54:16 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: Remove unnecessary amsdu/ampdu assignment in debugfs
References: <1448902779-3582-1-git-send-email-mohammed@qca.qualcomm.com>
Date: Tue, 8 Dec 2015 16:53:59 +0200
In-Reply-To: <1448902779-3582-1-git-send-email-mohammed@qca.qualcomm.com>
	(Mohammed Shafi Shajakhan's message of "Mon, 30 Nov 2015 22:29:39
	+0530")
Message-ID: <87wpsp9ek8.fsf@kamboji.qca.qualcomm.com> (sfid-20151208_155419_682323_226497A7)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com> writes:

> From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
>
> The default values of max_num_amsdu / max_num_amdpu is assigned a
> default value as part of 'ath10k_core_init_firmware_features'
>
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

Applied, thanks.

-- 
Kalle Valo

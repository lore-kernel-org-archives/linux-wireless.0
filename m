Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:56461 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbaIJLXX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2014 07:23:23 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Matteo Croce <matteo@openwrt.org>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: ATH10K_DEBUGFS depends on DEBUG_FS
References: <1409835069-2246-1-git-send-email-matteo@openwrt.org>
Date: Wed, 10 Sep 2014 14:23:17 +0300
In-Reply-To: <1409835069-2246-1-git-send-email-matteo@openwrt.org> (Matteo
	Croce's message of "Thu, 4 Sep 2014 14:51:09 +0200")
Message-ID: <87zje77m8q.fsf@kamboji.qca.qualcomm.com> (sfid-20140910_132343_032483_25454CBA)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Matteo Croce <matteo@openwrt.org> writes:

> ATH10K_DEBUGFS must depend on DEBUG_FS, otherwise
> ath10k will generate an invalid pointer on module load
>
> Signed-off-by: Matteo Croce <matteo@openwrt.org>

Thanks, applied.

-- 
Kalle Valo

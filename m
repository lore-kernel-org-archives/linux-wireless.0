Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:8073 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568AbaIKUpo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2014 16:45:44 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3] ath10k: fix debugfs_create_dir() checking
References: <1409827005-3777-1-git-send-email-michal.kazior@tieto.com>
Date: Thu, 11 Sep 2014 23:45:29 +0300
In-Reply-To: <1409827005-3777-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 4 Sep 2014 12:36:45 +0200")
Message-ID: <87r3zh28eu.fsf@kamboji.qca.qualcomm.com> (sfid-20140911_224547_338324_3EA35F57)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> The function may return an -ENODEV if debugfs is
> disabled in kernel. This should originally be
> guarded by ath10k's Kconfig but it still makes
> sense to check for the non-NULL errno return
> value.
>

[...]

> Reported-by: Matteo Croce <matteo@openwrt.org>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo

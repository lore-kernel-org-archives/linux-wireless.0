Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57403 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932076AbbBZNAY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Feb 2015 08:00:24 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [1/7] ath9k: Fix descriptors for keep-alive frame
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1423111964-19626-2-git-send-email-sujith@msujith.org>
To: Sujith Manoharan <sujith@msujith.org>
Cc: linux-wireless@vger.kernel.org
Message-Id: <20150226130024.13350140424@smtp.codeaurora.org> (sfid-20150226_140028_892265_168935A6)
Date: Thu, 26 Feb 2015 13:00:24 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> 
> Along with AR9462, AR9565 also has an extra field
> in the TX descriptor which needs to be zeroed out
> for the keep alive frame. This makes the earlier
> REG_WRITE redundant, so it can be removed.
> 
> Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Thanks, 7 patches applied to wireless-drivers-next.git:

2a0eef1ac629 ath9k: Fix descriptors for keep-alive frame
0d35024cad0f ath9k: Set keep awake timer
ff6f0c036b32 ath9k: Add new MCI states
b39adc63bf0c ath9k: Check MCI PowerSave state
6aaefab6cfe8 ath9k: Handle additional patterns on wakeup
3277b20270ee ath9k: Clear additional WoW events
aa96af82b873 ath9k: Restart TSF2 timers on wakeup

Kalle Valo

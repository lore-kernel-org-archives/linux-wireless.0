Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:24235 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037Ab1LMNK6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Dec 2011 08:10:58 -0500
Message-ID: <4EE74ED6.1040004@qca.qualcomm.com> (sfid-20111213_141102_092525_5754D511)
Date: Tue, 13 Dec 2011 15:10:46 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH V2 2/2] ath6kl: Use cfg80211_roamed_bss() to report roaming
 event
References: <1323776997-2962-1-git-send-email-vthiagar@qca.qualcomm.com>
In-Reply-To: <1323776997-2962-1-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/13/2011 01:49 PM, Vasanthakumar Thiagarajan wrote:
> This is to avoid the scenario where the bss entry of the AP got
> expired when reporting roaming event to current AP. As the bss
> entry for the current bss is available in driver, pass this bss
> to cfg80211. This fixes WARNING: at net/wireless/sme.c:586.
> 
> This patch depends on the following patch in cfg80211
> "cfg80211: Fix race in bss timeout".
> 
> Reported-by: Kalle Valo <kvalo@qca.qualcomm.com>
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>

Thanks. I'll wait for John to apply the dependency first and then I'll
take the patch.

Kalle

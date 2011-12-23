Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:14529 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab1LWMkr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Dec 2011 07:40:47 -0500
Message-ID: <4EF476C8.8070909@qca.qualcomm.com> (sfid-20111223_134106_305521_CB7795E2)
Date: Fri, 23 Dec 2011 14:40:40 +0200
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

Thanks, applied.

Kalle

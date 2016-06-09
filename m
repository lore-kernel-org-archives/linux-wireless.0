Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57891 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbcFIKjW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2016 06:39:22 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Benjamin Berg <benjamin@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
	ath9k-devel@lists.ath9k.org,
	Benjamin Berg <benjamin.berg@open-mesh.com>
Subject: Re: [PATCH 3/6] ath9k: Use tsf offset helper in ath9k_hw_reset
References: <1465305001-26067-1-git-send-email-benjamin@sipsolutions.net>
	<1465305001-26067-3-git-send-email-benjamin@sipsolutions.net>
Date: Thu, 09 Jun 2016 13:39:14 +0300
In-Reply-To: <1465305001-26067-3-git-send-email-benjamin@sipsolutions.net>
	(Benjamin Berg's message of "Tue, 7 Jun 2016 15:09:58 +0200")
Message-ID: <87inxiir3h.fsf@kamboji.qca.qualcomm.com> (sfid-20160609_123926_393279_DC770447)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Benjamin Berg <benjamin@sipsolutions.net> writes:

> From: Benjamin Berg <benjamin.berg@open-mesh.com>
>
> Not much of a change. Only small fix is that we don't assume that
> exactly 1.5ms have passed for the second AR91xx SoC TSF setting.
>
> Signed-off-by: Benjamin Berg <benjamin.berg@open-mesh.com>

Why we don't need that 1.5 ms delta anymore? It would be good to
document that in the commit log in case someone else wonders why that
change was made.

-- 
Kalle Valo

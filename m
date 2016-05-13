Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:15021 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948AbcEMPNo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2016 11:13:44 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "Shajakhan, Mohammed Shafi (Mohammed Shafi)"
	<mohammed@qti.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"mohammed@codeaurora.org" <mohammed@codeaurora.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3 RESEND 1/2] ath10k: Add support for
 ath10k_sta_statistics support
Date: Fri, 13 May 2016 15:13:36 +0000
Message-ID: <87ziru9ejj.fsf@kamboji.qca.qualcomm.com> (sfid-20160513_171348_758440_C55E31DA)
References: <1462204347-31012-1-git-send-email-mohammed@qca.qualcomm.com>
In-Reply-To: <1462204347-31012-1-git-send-email-mohammed@qca.qualcomm.com>
	(Mohammed Shafi Shajakhan's message of "Mon, 2 May 2016 21:22:27	+0530")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com> writes:

> From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
>
> Enable support for 'drv_sta_statistics' callback.
> Export rx_duration support if available to cfg80211/nl80211
>
> This can also act as a placeholder for any new per STA stats support
>
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> ---
> [v3] removed conditions for ath10k state checks based on Michal's suggestion

It's nicer to ping than resend a patch. This patchset has been in
"Awaiting Upstream" state while waiting for the dependencies trickle
down to ath-next.

> Dependencies:
>
> 1. cfg80211/nl80211: Add support for NL80211_STA_INFO_RX_DURATION (under review)

739960f128e5 cfg80211/nl80211: Add support for NL80211_STA_INFO_RX_DURATION

Currently in net-next, should come to ath-next soon.

-- 
Kalle Valo
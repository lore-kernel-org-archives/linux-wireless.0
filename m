Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:21701 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbcDOLna convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Apr 2016 07:43:30 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "Shajakhan, Mohammed Shafi (Mohammed Shafi)"
	<mohammed@qti.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"mohammed@codeaurora.org" <mohammed@codeaurora.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3 1/2] ath10k: Add support for ath10k_sta_statistics
 support
Date: Fri, 15 Apr 2016 11:43:22 +0000
Message-ID: <87r3e7qeqv.fsf@kamboji.qca.qualcomm.com> (sfid-20160415_134334_625529_251571C2)
References: <1459241642-3730-1-git-send-email-mohammed@qca.qualcomm.com>
In-Reply-To: <1459241642-3730-1-git-send-email-mohammed@qca.qualcomm.com>
	(Mohammed Shafi Shajakhan's message of "Tue, 29 Mar 2016 14:24:01	+0530")
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
>
> Dependencies:
>
> 1. cfg80211/nl80211: Add support for NL80211_STA_INFO_RX_DURATION (under review)
> 2. iw: Add support for NL80211_STA_INFO_RX_DURATION netlink
>  attribute (under review)
> 3. ath10k: Enable debugfs provision to enable Peer Stats feature (merged in pending branch)

The dependency is in mac80211-next currently:

49da43f94f5e cfg80211/nl80211: Add support for NL80211_STA_INFO_RX_DURATION

(Sorry for the noise, I wish patchwork would have a feature to add
notes)

-- 
Kalle Valo
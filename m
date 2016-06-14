Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:53888 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbcFNN6k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jun 2016 09:58:40 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "Shajakhan, Mohammed Shafi (Mohammed Shafi)"
	<mohammed@qti.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"mohammed@codeaurora.org" <mohammed@codeaurora.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v4 1/2] ath10k: Add support for ath10k_sta_statistics
 support
Date: Tue, 14 Jun 2016 13:58:25 +0000
Message-ID: <87k2hr3m9r.fsf@kamboji.qca.qualcomm.com> (sfid-20160614_155843_796952_747844FD)
References: <1465890866-2390-1-git-send-email-mohammed@qca.qualcomm.com>
In-Reply-To: <1465890866-2390-1-git-send-email-mohammed@qca.qualcomm.com>
	(Mohammed Shafi Shajakhan's message of "Tue, 14 Jun 2016 13:24:25	+0530")
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
>
> [v4] rebased over 'pending' branch
> [v3] removed conditions for ath10k state checks based on Michal's suggestion
>
> Both the dependent changes are merged now in master tree
>
> 1. cfg80211/nl80211: Add support for NL80211_STA_INFO_RX_DURATION
> 2. iw: Add support for NL80211_STA_INFO_RX_DURATION netlink
>  attribute

But these are not in ath-next branch yet, so I can't take these until I
have updated ath-next.

Also please ping instead of resending patches. These are already waiting
in patchwork:

https://patchwork.kernel.org/patch/8993601/
https://patchwork.kernel.org/patch/8993621/

-- 
Kalle Valo
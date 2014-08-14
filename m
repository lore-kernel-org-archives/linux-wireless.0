Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:61061 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754064AbaHNI5I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Aug 2014 04:57:08 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes.berg@intel.com>,
	<ath6kl@lists.infradead.org>
Subject: Re: [PATCH 2/2] cfg80211: allow passing frame type to cfg80211_inform_bss()
References: <1407870219-1720-1-git-send-email-johannes@sipsolutions.net>
	<1407870219-1720-2-git-send-email-johannes@sipsolutions.net>
Date: Thu, 14 Aug 2014 11:57:00 +0300
In-Reply-To: <1407870219-1720-2-git-send-email-johannes@sipsolutions.net>
	(Johannes Berg's message of "Tue, 12 Aug 2014 21:03:39 +0200")
Message-ID: <8761hvo3dv.fsf@kamboji.qca.qualcomm.com> (sfid-20140814_105718_944561_B271E0B3)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> From: Johannes Berg <johannes.berg@intel.com>
>
> When using the cfg80211_inform_bss[_width]() functions drivers
> cannot currently indicate whether the data was received in a
> beacon or probe response. Fix that by passing a new enum that
> indicates such (or unknown).
>
> For good measure, use it in ath6kl.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  drivers/net/wireless/ath/ath6kl/cfg80211.c         |  1 +
>  drivers/net/wireless/ath/ath6kl/wmi.c              | 43 +++++-----------------

Thanks. For the ath6kl part:

Acked-by: Kalle Valo <kvalo@qca.qualcomm.com>

-- 
Kalle Valo

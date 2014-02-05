Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:18638 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbaBEOts (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Feb 2014 09:49:48 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
CC: <johannes@sipsolutions.net>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] mac80211: move VHT related RX_FLAG to another variable
References: <1391611031-29099-1-git-send-email-emmanuel.grumbach@intel.com>
Date: Wed, 5 Feb 2014 16:49:43 +0200
In-Reply-To: <1391611031-29099-1-git-send-email-emmanuel.grumbach@intel.com>
	(Emmanuel Grumbach's message of "Wed, 5 Feb 2014 16:37:11 +0200")
Message-ID: <87ppn1k41k.fsf@kamboji.qca.qualcomm.com> (sfid-20140205_154952_014327_2A272C6A)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Emmanuel Grumbach <emmanuel.grumbach@intel.com> writes:

> ieee80211_rx_status.flags is full. Define a new vht_flag
> variable to be able to set more VHT related flags and make
> room in flags.
>
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> ---
> v2: Fix ath10k compilation
> ---
>  drivers/net/wireless/ath/ath10k/txrx.c |  4 ++--
>  drivers/net/wireless/iwlwifi/mvm/rx.c  |  4 ++--
>  include/net/mac80211.h                 | 23 +++++++++++++++++------
>  net/mac80211/cfg.c                     |  6 +++---
>  net/mac80211/rx.c                      |  9 +++++----
>  net/mac80211/sta_info.h                |  2 ++
>  net/mac80211/util.c                    |  6 +++---
>  7 files changed, 34 insertions(+), 20 deletions(-)

For ath10k changes:

Acked-by: Kalle Valo <kvalo@qca.qualcomm.com>

-- 
Kalle Valo

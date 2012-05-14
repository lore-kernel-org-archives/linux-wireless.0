Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:28994 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947Ab2ENGQg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 May 2012 02:16:36 -0400
Message-ID: <4FB0A33B.4050409@qca.qualcomm.com> (sfid-20120514_081639_479253_791607D8)
Date: Mon, 14 May 2012 09:16:27 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 3/3] cfg80211: provide channel to start_ap function
References: <20120511083413.778117363@sipsolutions.net> <20120511083720.868662963@sipsolutions.net>
In-Reply-To: <20120511083720.868662963@sipsolutions.net>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/11/2012 11:34 AM, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Instead of setting the channel first and then
> starting the AP, let cfg80211 store the channel
> and provide it as one of the AP settings.
> 
> This means that now you have to set the channel
> before you can start an AP interface, but since
> hostapd/wpa_supplicant always do that we're OK
> with this change.
> 
> Alternatively, it's now possible to give the
> channel as an attribute to the start-ap nl80211
> command, overriding any preset channel.
> 
> Cc: Kalle Valo <kvalo@qca.qualcomm.com>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

For the ath6kl part:

Acked-by: Kalle Valo <kvalo@qca.qualcomm.com>

Kalle

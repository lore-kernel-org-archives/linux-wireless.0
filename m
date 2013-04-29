Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:52865 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756916Ab3D2KPG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Apr 2013 06:15:06 -0400
Message-ID: <1367230485.8289.0.camel@jlt4.sipsolutions.net> (sfid-20130429_121511_778483_95BEA90F)
Subject: Re: [PATCH 2/4] mac80211: add STBC flag for radiotap
From: Johannes Berg <johannes@sipsolutions.net>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Date: Mon, 29 Apr 2013 12:14:45 +0200
In-Reply-To: <1367228024-17936-3-git-send-email-linux@rempel-privat.de> (sfid-20130429_113400_548526_A3E50994)
References: <1367228024-17936-1-git-send-email-linux@rempel-privat.de>
	 <1367228024-17936-3-git-send-email-linux@rempel-privat.de>
	 (sfid-20130429_113400_548526_A3E50994)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-04-29 at 11:33 +0200, Oleksij Rempel wrote:

> --- a/include/net/ieee80211_radiotap.h
> +++ b/include/net/ieee80211_radiotap.h
> @@ -269,6 +269,7 @@ enum ieee80211_radiotap_type {
>  #define IEEE80211_RADIOTAP_MCS_HAVE_GI		0x04
>  #define IEEE80211_RADIOTAP_MCS_HAVE_FMT		0x08
>  #define IEEE80211_RADIOTAP_MCS_HAVE_FEC		0x10
> +#define IEEE80211_RADIOTAP_MCS_HAVE_STBC	0x20

Umm, need to do radiotap standardisation process, so NACK until then.

johannes


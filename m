Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39089 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003Ab3LBOkM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Dec 2013 09:40:12 -0500
Message-ID: <1385995208.20277.1.camel@jlt4.sipsolutions.net> (sfid-20131202_154018_741787_E55ABFCA)
Subject: Re: [PATCH 2/2] mac80211: Update opmode during adding new station
From: Johannes Berg <johannes@sipsolutions.net>
To: Marek Kwaczynski <marek.kwaczynski@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 02 Dec 2013 15:40:08 +0100
In-Reply-To: <1385994534-13383-2-git-send-email-marek.kwaczynski@tieto.com> (sfid-20131202_152938_476020_C588DC36)
References: <1385994534-13383-1-git-send-email-marek.kwaczynski@tieto.com>
	 <1385994534-13383-2-git-send-email-marek.kwaczynski@tieto.com>
	 (sfid-20131202_152938_476020_C588DC36)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-12-02 at 15:28 +0100, Marek Kwaczynski wrote:

> -void ieee80211_vht_handle_opmode(struct ieee80211_sub_if_data *sdata,
> +void ieee80211_vht_recalc_opmode(struct ieee80211_sub_if_data *sdata,
>  				 struct sta_info *sta, u8 opmode,
> -				 enum ieee80211_band band, bool nss_only)
> +				 enum ieee80211_band band, bool nss_only,
> +				 u32 *changed)

Also - void return and u32 * argument is stupid.

johannes


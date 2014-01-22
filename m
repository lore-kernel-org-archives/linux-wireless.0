Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42378 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876AbaAVV1G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 16:27:06 -0500
Message-ID: <1390426022.4334.50.camel@jlt4.sipsolutions.net> (sfid-20140122_222710_932658_73C74047)
Subject: Re: [PATCH] minstrel_ht:  Use RTS_CTS when STA is in DYNAMIC SMPS
 mode for frames sent using Nss>1.
From: Johannes Berg <johannes@sipsolutions.net>
To: Chaitanya T K <chaitanya.mgit@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 22 Jan 2014 22:27:02 +0100
In-Reply-To: <1390373865-6088-1-git-send-email-chaitanya.mgit@gmail.com> (sfid-20140122_220916_338336_2620AEB0)
References: <1390373865-6088-1-git-send-email-chaitanya.mgit@gmail.com>
	 (sfid-20140122_220916_338336_2620AEB0)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-01-22 at 12:27 +0530, Chaitanya T K wrote:

> +		if (sta->smps_mode == IEEE80211_SMPS_DYNAMIC &&
> +			minstrel_mcs_groups[i].streams > 1) {
> +			mi->tx_flags |= IEEE80211_TX_RC_USE_RTS_CTS;
> +		} else if (sta->smps_mode == IEEE80211_SMPS_STATIC &&
> +			minstrel_mcs_groups[i].streams > 1) {

Your indentation is off inside the if statements. I'll have to wait for
nbd to review the patch itself, I guess.

johannes

PS: Your clock/timezone is wrong by approximately 10 hours.


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43017 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755883Ab3BKLuJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2013 06:50:09 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1U4rtg-0000kY-Po
	for linux-wireless@vger.kernel.org; Mon, 11 Feb 2013 12:50:08 +0100
Message-ID: <1360583405.8738.22.camel@jlt4.sipsolutions.net> (sfid-20130211_125014_062966_75DEE3F8)
Subject: Re: [PATCH] mac80211: introduce beacon-only timing data
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Mon, 11 Feb 2013 12:50:05 +0100
In-Reply-To: <1360160966-26163-1-git-send-email-johannes@sipsolutions.net> (sfid-20130206_152911_650604_90D399DD)
References: <1360160966-26163-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130206_152911_650604_90D399DD)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-02-06 at 15:29 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> In order to be able to predict the next DTIM TBTT
> in the driver, add the ability to use timing data
> from beacons only with the new hardware flag
> IEEE80211_HW_TIMING_BEACON_ONLY and the BSS info
> value sync_dtim_count which is only valid if the
> timing data came from a beacon. The data can only
> come from a beacon, and if no beacon was received
> before association it is updated later together
> with the DTIM count notification.

Applied.

johannes


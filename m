Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43296 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755920Ab3BDPJK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2013 10:09:10 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1U2NfR-0002ZH-Eq
	for linux-wireless@vger.kernel.org; Mon, 04 Feb 2013 16:09:09 +0100
Message-ID: <1359990574.10311.7.camel@jlt4.sipsolutions.net> (sfid-20130204_160913_894137_29A77F9A)
Subject: Re: [PATCH 2/2] mac80211: always allow calling
 ieee80211_connection_loss()
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Mon, 04 Feb 2013 16:09:34 +0100
In-Reply-To: <1359637562-22399-2-git-send-email-johannes@sipsolutions.net> (sfid-20130131_140548_036156_85A6E9E7)
References: <1359637562-22399-1-git-send-email-johannes@sipsolutions.net>
	 <1359637562-22399-2-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130131_140548_036156_85A6E9E7)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-01-31 at 14:06 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> With multi-channel, there's a corner case where a driver
> doesn't receive a beacon soon enough to be able to sync
> its timers with the AP. In this case, the only recovery
> (after trying again) is to disconnect from the AP. Allow
> calling ieee80211_connection_loss() for such cases. To
> make that possible, modify the work function to not rely
> on the IEEE80211_HW_CONNECTION_MONITOR flag but use new
> state kept in the interface instead.

Applied.

johannes


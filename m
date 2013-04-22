Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45813 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561Ab3DVNfm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Apr 2013 09:35:42 -0400
Message-ID: <1366637736.8637.10.camel@jlt4.sipsolutions.net> (sfid-20130422_153548_742388_B10CD5C7)
Subject: Re: [PATCH] mac80211: fix P2P-Device management frame RX
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: david.spinadel@intel.com, arend@broadcom.com
Date: Mon, 22 Apr 2013 15:35:36 +0200
In-Reply-To: <1366321606-10967-1-git-send-email-johannes@sipsolutions.net> (sfid-20130418_234701_386587_D5A8A956)
References: <1366321606-10967-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130418_234701_386587_D5A8A956)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-04-18 at 23:46 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> There's an issue in receiving broadcast management frames
> on P2P Device virtual interfaces, such frames have the RX
> flag IEEE80211_RX_RA_MATCH cleared and are thus dropped
> in ieee80211_rx_h_mgmt_check(). They should be let through
> to make it to ieee80211_rx_h_userspace_mgmt() and then to
> userspace.

Applied.

johannes


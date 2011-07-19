Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34423 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080Ab1GSKK7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2011 06:10:59 -0400
Subject: Re: [PATCH] mac80211: sync driver before TX
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kvalo@adurom.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <87oc0qtxeg.fsf@purkki.adurom.net>
References: <1311064793.24078.0.camel@jlt3.sipsolutions.net>
	 <87oc0qtxeg.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Jul 2011 12:10:53 +0200
Message-ID: <1311070253.24078.2.camel@jlt3.sipsolutions.net> (sfid-20110719_121102_704256_B6EB1616)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-07-19 at 12:47 +0300, Kalle Valo wrote:

> > +	int (*tx_sync)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
> > +		       const u8 *bssid, enum ieee80211_tx_sync_type type);
> 
> With these it should be possible to get bssid before authentication
> and we would get at76c50x-usb working again. Did I understand
> correctly?

Yes.

johannes


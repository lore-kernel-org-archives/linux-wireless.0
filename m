Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:63442 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792Ab2HLFfG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Aug 2012 01:35:06 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20519.16305.788311.804773@gargle.gargle.HOWL> (sfid-20120812_073510_802910_BC443B0B)
Date: Sun, 12 Aug 2012 11:01:29 +0530
To: Antonio Quartulli <ordex@autistici.org>
CC: Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	<ath9k-devel@lists.ath9k.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] [PATCH 1/2] mac80211: add sta_update_rates
	callback
In-Reply-To: <20519.15997.154761.163636@gargle.gargle.HOWL>
References: <1344474712-22561-1-git-send-email-ordex@autistici.org>
	<1344492897.4494.1.camel@jlt3.sipsolutions.net>
	<20120809093245.GG6767@ritirata.org>
	<20519.15997.154761.163636@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith Manoharan wrote:
> We didn't have this new callback back then, and sta_rc_update() is sufficient to
> fix this. Maybe with a new flag - IEEE80211_RC_BASIC_RATES_CHANGED.

Um, IEEE80211_RC_SUPP_RATES_CHANGED or something.

Sujith

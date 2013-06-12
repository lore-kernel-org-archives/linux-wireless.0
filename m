Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:36236 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752763Ab3FLGhZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jun 2013 02:37:25 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Calvin Owens <jcalvinowens@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Felix Fietkau <nbd@openwrt.org>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, netdev@vger.kernel.org
Subject: Re: [PATCH] mac80211: ath9k: Use RCU protection calling ieee80211_get_tx_rates
References: <20130609225120.GA2789@gmail.com>
	<20130610042959.GA1902@gmail.com>
	<1370950926.8356.14.camel@jlt4.sipsolutions.net>
	<20130611171304.GA2189@gmail.com>
	<1370980523.8356.70.camel@jlt4.sipsolutions.net>
Date: Wed, 12 Jun 2013 09:37:18 +0300
In-Reply-To: <1370980523.8356.70.camel@jlt4.sipsolutions.net> (Johannes Berg's
	message of "Tue, 11 Jun 2013 21:55:23 +0200")
Message-ID: <87ehc73kdd.fsf@purkki.adurom.net> (sfid-20130612_083728_111045_C185C19D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> Now the subject should no longer say "mac80211:" :)

It did have a change to mac80211.h as well, but IMHO that should be in a
separate patch.

-- 
Kalle Valo

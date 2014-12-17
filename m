Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36129 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbaLQKrj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2014 05:47:39 -0500
Message-ID: <1418813252.2135.5.camel@sipsolutions.net> (sfid-20141217_114742_093085_0F5BBE66)
Subject: Re: [PATCH v2] mac80211: notify NSS changed when IBSS and HT
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Date: Wed, 17 Dec 2014 11:47:32 +0100
In-Reply-To: <1418806852-558-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20141217_100158_628858_A7FE3DB6)
References: <1418806852-558-1-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20141217_100158_628858_A7FE3DB6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-12-17 at 10:00 +0100, Janusz Dziedzic wrote:
> When using IBSS in HT mode, we always get NSS=1
> in rc_update callback. Force NSS recalculation when
> rates updated and notify driver that NSS changed.

Applied.

johannes


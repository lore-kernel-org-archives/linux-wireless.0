Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49416 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab1KIWMt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Nov 2011 17:12:49 -0500
Subject: Re: New wireless-testing has grown some warnings -- please fix
 ASAP!
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20111109215007.GD10712@tuxdriver.com> (sfid-20111109_230016_428309_0817D10D)
References: <20111109215007.GD10712@tuxdriver.com>
	 (sfid-20111109_230016_428309_0817D10D)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Nov 2011 23:12:43 +0100
Message-ID: <1320876763.3845.148.camel@jlt3.sipsolutions.net> (sfid-20111109_231253_039649_2EFA6D99)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-11-09 at 16:50 -0500, John W. Linville wrote:

>   CC [M]  net/wireless/nl80211.o
> net/wireless/nl80211.c: In function ‘nl80211_tx_mgmt’:
> net/wireless/nl80211.c:5286:8: warning: ‘hdr’ may be used uninitialized in this function

Hm, my compiler is smarter than yours ;-)

Not quite sure how to fix this best, I'll figure out something. Thanks
for the heads-up.

johannes



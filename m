Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49364 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067Ab0DIORi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Apr 2010 10:17:38 -0400
Subject: Re: ath9k/mac80211 and 802.11n in IBSS mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Joerg Pommnitz <pommnitz@yahoo.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
In-Reply-To: <382964.83589.qm@web51407.mail.re2.yahoo.com>
References: <382964.83589.qm@web51407.mail.re2.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Apr 2010 16:17:35 +0200
Message-ID: <1270822655.3870.21.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-04-09 at 03:03 -0700, Joerg Pommnitz wrote:
> Hello all,
> the Atheros Windows drivers provide an option to enable 802.11n mode
> for IBSS networks. I did not find any information in this regard for
> mac80211 based drivers. So, is this supported and how would I enable
> this feature? And, btw. what exactly would this mean?

Benoit was working on this, but his last patchset missed the ability to
actually configure this when requesting an IBSS join.

johannes


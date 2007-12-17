Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:59279 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755707AbXLQVJP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Dec 2007 16:09:15 -0500
Subject: Re: [patch 7/9] mac80211: Dump rc80211_pid events to debugfs
From: Mattias Nissler <mattias.nissler@gmx.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1197892636.4885.25.camel@johannes.berg>
References: <20071217012517.882216322@gmx.de> >
	 <20071217012550.464889334@gmx.de> >
	 (sfid-20071217_012731_162132_E62DF268)  <1197892636.4885.25.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 17 Dec 2007 22:09:11 +0100
Message-Id: <1197925751.7505.19.camel@localhost> (sfid-20071217_210917_970240_1D42051F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Mon, 2007-12-17 at 12:57 +0100, Johannes Berg wrote:
> > +#ifdef CONFIG_MAC80211_DEBUGFS
> > +#include "rc80211_pid_debugfs.h"
> > +#endif
> > +#include "rc80211_pid.h"
> 
> Don't ifdef includes. Also, I think it's overkill to have two header
> files for a single rate control algorithm, just use a single combined
> one.

Will do.

Mattias


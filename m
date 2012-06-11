Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53125 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754672Ab2FKOpu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2012 10:45:50 -0400
Message-ID: <1339425944.4520.27.camel@jlt3.sipsolutions.net> (sfid-20120611_164608_904846_21E17C36)
Subject: Re: [RFC 0/3] wireless: add CONFIG_CFG80211_EXPERT
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, me@bobcopeland.com,
	mickflemm@gmail.com
Date: Mon, 11 Jun 2012 16:45:44 +0200
In-Reply-To: <4FD60369.80108@qca.qualcomm.com>
References: <1339203070-17979-1-git-send-email-rodrigue@qca.qualcomm.com>
	  <1339228530.4539.0.camel@jlt3.sipsolutions.net>
	  <4FD3A936.8070600@broadcom.com>
	 <1339399952.4520.13.camel@jlt3.sipsolutions.net>
	 <4FD60369.80108@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-06-11 at 17:40 +0300, Kalle Valo wrote:

> > I still don't see the need. What would you put under it in
> > brcm[sf]mac? I certainly wouldn't see any reason to put anything
> > under it in our driver since it's much simpler to .
> 
> Looks like something is missing here?

Sorry, yeah,  Iwas going to say it's simpler to put something under the
driver's Kconfig.

> > Also, the argument about distros doesn't really work that way, if
> > there are users interested in something then the distros will
> > certainly enable this (CFG80211_EXPERT) option to get something
> > hidden behind it.
> 
> I would compare this with NL80211_TESTMODE, we don't want distributions
> to enable that either. Of course nothing prevents distros to enable
> CFG80211_EXPERT but we need to be active to make sure it's not enabled
> (ie. check the distro configs and file bugs etc).

Right, but that's actually a feature. I see little value in a pretty
much meaningless "EXPERT wireless" Kconfig symbol that only groups
others. If, as Arend suggested, it actually has some meaning, then it
may make more sense.

johannes


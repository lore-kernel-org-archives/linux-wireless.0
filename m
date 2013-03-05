Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46832 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759065Ab3CESxp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Mar 2013 13:53:45 -0500
Message-ID: <1362509619.8224.5.camel@jlt4.sipsolutions.net> (sfid-20130305_195348_252961_D11E5D44)
Subject: Re: [PATCH v2 1/2] mac80211: get the rates masks from the txrc in
 rate_control_get_rate
From: Johannes Berg <johannes@sipsolutions.net>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: Felix Fietkau <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Date: Tue, 05 Mar 2013 19:53:39 +0100
In-Reply-To: <20130305161003.GA30419@magnum.frso.rivierawaves.com> (sfid-20130305_171303_214356_26AB9ADD)
References: <1362421635-28008-1-git-send-email-karl.beldan@gmail.com>
	 <1362427924.21028.42.camel@jlt4.sipsolutions.net>
	 <20130304204541.GA8819@gobelin> <5135F327.4000408@openwrt.org>
	 <20130305161003.GA30419@magnum.frso.rivierawaves.com>
	 (sfid-20130305_171303_214356_26AB9ADD)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-03-05 at 17:10 +0100, Karl Beldan wrote:

> > It seems to me that all of this could be made more efficient by default
> > if a mcs mask pointer is only passed to rate control if the user
> > actually configured a MCS mask. Also, filtering out rates from the mask
> > that the sta does not support seems a bit unnecessary, since the rate
> > control usually looks at the HT capabilities and the sta's mcs rx mask
> > anyway.
> > 
> Yes, some things look a bit overkill in the masks logic.

Are you planning to send new patches to improve this?

johannes


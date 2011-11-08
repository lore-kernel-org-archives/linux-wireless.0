Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41775 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755586Ab1KHTAR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 14:00:17 -0500
Subject: Re: [PATCH] mac80211/cfg80211: report monitor channel in wireless
 extensions
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4EB97B70.1010909@candelatech.com>
References: <1320778327.24797.36.camel@jlt3.sipsolutions.net>
	 <4EB97B70.1010909@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Nov 2011 20:00:13 +0100
Message-ID: <1320778813.24797.37.camel@jlt3.sipsolutions.net> (sfid-20111108_200022_118555_91EC4C15)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-11-08 at 10:56 -0800, Ben Greear wrote:
> On 11/08/2011 10:52 AM, Johannes Berg wrote:

> > +++ b/include/net/cfg80211.h	2011-11-08 19:49:33.000000000 +0100
> > @@ -1342,6 +1342,9 @@ struct cfg80211_gtk_rekey_data {
> >    *	doesn't verify much. Note, however, that the passed netdev may be
> >    *	%NULL as well if the user requested changing the channel for the
> >    *	device itself, or for a monitor interface.
> > + * @get_channel: Get the current operating channel, should return %NULL if
> > + *	there's no signal defined operating channel if for example the
> 
> Do you mean "no single defined" ?

Err, yes, thanks. Fingers faster than brain.

johannes


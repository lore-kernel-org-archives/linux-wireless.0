Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:35482 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753077AbXHKRBD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Aug 2007 13:01:03 -0400
Message-ID: <46BDEB49.2070703@lwfinger.net>
Date: Sat, 11 Aug 2007 12:00:57 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>, Jiri Benc <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 4/4] mac80211: remove radar stuff
References: <20070810220544.321975000@sipsolutions.net>	 <20070810220634.450509000@sipsolutions.net> <46BD2A89.8050906@lwfinger.net> <1186820267.5363.1.camel@johannes.berg>
In-Reply-To: <1186820267.5363.1.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Fri, 2007-08-10 at 22:18 -0500, Larry Finger wrote:
>> Johannes Berg wrote:
>>> Unused in drivers, userspace and mac80211.
>>>
>>> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
>>> ---
>> Won't 802.11a drivers need this? If so, does it hurt to leave it in for now?
> 
> Absolutely correct, they probably will. None of the ones we have,
> however, actually uses it, and it uses the management interface we're
> trying to get rid of for the notification. The same function should
> probably be added back to mac80211 or cfg80211 once somebody actually
> wants it, but do the notification
>  1) with well-defined arguments (explanation for the two args anyone?)
>  2) via nl80211
> 
> It doesn't really "hurt" but I'm trying to actually remove the master
> interface now and I'm almost there, so this code is in my way.

OK, thanks for the explanation.

Larry

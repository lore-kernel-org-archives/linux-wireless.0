Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38745 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430Ab0JGSfX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 14:35:23 -0400
Subject: Re: Vendor specific data within a beacon frame
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Bjoern Czybik <wlfw@gmx.com>, linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTimzwhBCVKFnx1vhM4A939_kgixEpw5RLTe8JJb0@mail.gmail.com>
References: <4CAD9368.70608@gmx.com>
	 <AANLkTimTLEShJ3HcBqHaU5U5nFq1UywczC=G7oiHx=as@mail.gmail.com>
	 <1286475342.20974.23.camel@jlt3.sipsolutions.net>
	 <AANLkTimzwhBCVKFnx1vhM4A939_kgixEpw5RLTe8JJb0@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Oct 2010 20:35:22 +0200
Message-ID: <1286476522.20974.27.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-10-07 at 11:31 -0700, Luis R. Rodriguez wrote:
> On Thu, Oct 7, 2010 at 11:15 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Thu, 2010-10-07 at 11:11 -0700, Luis R. Rodriguez wrote:
> >
> > Let me quote what you wrote, but just partially:
> >
> >> This can be done from userspace. This is from nl80211.h:
> >
> >>  *      Note: This command has been removed and it is only reserved at this
> >>  *      point to avoid re-using existing command number. The functionality this
> >>  *      command was planned for has been provided with cleaner design with the
> >>  *      option to specify additional IEs in NL80211_CMD_TRIGGER_SCAN,
> >>  *      NL80211_CMD_AUTHENTICATE, NL80211_CMD_ASSOCIATE,
> >>  *      NL80211_CMD_DEAUTHENTICATE, and NL80211_CMD_DISASSOCIATE.
> >
> > :P
> 
> Yeah just noticed *after* I pasted it and sent it. Does hostapd use
> this currently?

No, hostapd transmits frames via injection and the data it puts into the
beacon is conveyed with the beacon cmd -- it has never used this
command.

Really, what the OP is looking for is the annotated hostapd
configuration file or the hostapd source code -- he should be able to
figure that out for himself.

johannes


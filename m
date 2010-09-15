Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43809 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551Ab0IOOYg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Sep 2010 10:24:36 -0400
Subject: Re: RFC:  mac80211/ath9k:  allow scanning single channel if other
 VIF is associated.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: Jouni Malinen <j@w1.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4C90D683.7000801@candelatech.com>
References: <4C8EB03D.7070808@candelatech.com>
	 <20100915030316.GB30253@jm.kir.nu>  <4C9059DC.7060009@candelatech.com>
	 <1284545796.3842.11.camel@jlt3.sipsolutions.net>
	 <4C90D683.7000801@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Sep 2010 16:24:24 +0200
Message-ID: <1284560664.7705.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-09-15 at 07:21 -0700, Ben Greear wrote:

> Right, but as soon as one finished, the next would start, and at least in .31,
> that caused the first to un-associate, giving never-ending loop of interfaces
> scanning and trying to associate.

There should be a grace period maybe?

> Ok, I'll see if I can add a 'scan-one-if-associated' flag for wpa-supplicant to
> use.

Just make it give the channel instead of adding new API.

johannes


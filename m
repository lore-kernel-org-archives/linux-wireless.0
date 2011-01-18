Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53768 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123Ab1ARO5E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jan 2011 09:57:04 -0500
Subject: Re: intermittent eap authentication failure
From: Johannes Berg <johannes@sipsolutions.net>
To: Chuck Crisler <ccrisler@vgocom.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1F9D19D1999A4D7885D0A4DD7BEBCEE8@ChuckPC>
References: <D323CFEF4DEC4E18AFF56742F78C16B6@ChuckPC>
	 <1295347932.3563.13.camel@jlt3.sipsolutions.net>
	 <BB274B92115347F9A8E250DEF0C2B732@ChuckPC>
	 <1F9D19D1999A4D7885D0A4DD7BEBCEE8@ChuckPC>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Jan 2011 15:57:02 +0100
Message-ID: <1295362622.3563.23.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-01-18 at 09:54 -0500, Chuck Crisler wrote:
> I will have to reply later about why it is associating. I will have to add a 
> printk to my driver but I currently have 2 tests running and don't want to 
> stop either.
> It looks like it might be called by ieee80211_sta_work() in mlme.c because 
> it might still be in the IEEE80211_STA_MLME_ASSOCIATE state. I will confirm 
> that.

Did you ever consider using compat-wireless? Frankly, my main memory
isn't large enough to hold information about old mac80211 behaviour so I
have to get that information from swap (git tree) and that's really
slow :-)

johannes


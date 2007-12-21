Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:41524 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753966AbXLUUDM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Dec 2007 15:03:12 -0500
Date: Fri, 21 Dec 2007 21:00:17 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	sam <sam@ravnborg.org>, Michael Wu <flamingice@sourmilk.net>,
	Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH] mac80211: better rate control algorithm selection
Message-ID: <20071221210017.36f34fe3@morte> (sfid-20071221_200314_528086_7105F300)
In-Reply-To: <1198253375.16241.76.camel@johannes.berg>
References: <1198253375.16241.76.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 21 Dec 2007 17:09:35 +0100
Johannes Berg <johannes@sipsolutions.net> wrote:

> Below is the patch, comments welcome. I think this is the way we want
> it, tristate for all rate control algorithms regardless of whether
> mac80211 is modular (where =y then means "build algorithm into
> mac80211") and forcing one of the algorithms to y to do exactly that.

What about avoiding to force any algorithm to y, and instead always build a
dummy (a few lines of code which would just set the rate to the lowest
available) rate control algorithm into mac80211?

Looks good otherwise.


--
Ciao
Stefano

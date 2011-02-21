Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44227 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889Ab1BUKg4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Feb 2011 05:36:56 -0500
Subject: Re: multiqueue behavior?
From: Johannes Berg <johannes@sipsolutions.net>
To: Dave =?ISO-8859-1?Q?T=E4ht?= <d@taht.net>
Cc: wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <87hbc06avr.fsf@cruithne.co.teklibre.org>
References: <87hbc06avr.fsf@cruithne.co.teklibre.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Feb 2011 11:36:54 +0100
Message-ID: <1298284614.3707.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-02-18 at 19:01 -0700, Dave Täht wrote:
> I LOVED your diagram of how it is supposed to all work. What I don't
> understand is how on earth stuff gets into the different queues in the
> first place. From my talk with felix it seemed apparent that he didn't
> know how that actually worked, and I for one, wouldn't mind figuring out
> how/when those queues actually get used. 
> 
> It looked to me that the only way that they got into a different queue
> was with some sort of skb marking.

Take a look at net/wireless/util.c cfg80211_classify8021d(). I've also
expanded the description on the wiki page a bit.

johannes


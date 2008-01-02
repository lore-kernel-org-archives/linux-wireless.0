Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:58968 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989AbYABP3z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2008 10:29:55 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: better rate control algorithm selection
Date: Wed, 2 Jan 2008 16:29:15 +0100
Cc: Christoph Hellwig <hch@infradead.org>,
	Sam Ravnborg <sam@ravnborg.org>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>
References: <1198253375.16241.76.camel@johannes.berg> <200801021623.36089.mb@bu3sch.de> <1199287652.4172.90.camel@johannes.berg>
In-Reply-To: <1199287652.4172.90.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200801021629.15594.mb@bu3sch.de> (sfid-20080102_152957_588817_83C8261D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 02 January 2008 16:27:32 Johannes Berg wrote:
> 
> > What about simply _not_ failing the initialization of mac80211, if no
> > rc algo is available? I mean, we can just use a fixed rate we get through
> > WEXT and stuff. Simply start at 1M on init in that case and stay at a fixed
> > 1M until the user sets a different fixed rate through WEXT.
> 
> Not sure. I think I'd prefer not to have all special cases all over, I'd
> much prefer a new rc80211_none or so then.

That's fine with me, too. It's just a different implementation of the same idea.

-- 
Greetings Michael.

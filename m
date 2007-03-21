Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:52478 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752887AbXCUOMe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Mar 2007 10:12:34 -0400
Date: Wed, 21 Mar 2007 15:12:31 +0100
From: Jiri Benc <jbenc@suse.cz>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: question: /sys/class/net/*/wireless
Message-ID: <20070321151231.0a912abf@griffin.suse.cz>
In-Reply-To: <1174064833.3355.7.camel@johannes.berg>
References: <1172920691.4966.6.camel@johannes.berg>
	<1172921257.4966.12.camel@johannes.berg>
	<1172967669.3402.0.camel@johannes.berg>
	<20070316150352.5290eea7@griffin.suse.cz>
	<1174064833.3355.7.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 16 Mar 2007 18:07:12 +0100, Johannes Berg wrote:
> On Fri, 2007-03-16 at 15:03 +0100, Jiri Benc wrote:
> > Then we can have /sys/class/net/*/ieee80211 for cfg80211-based
> > interfaces.
> 
> And /wireless just present for wext? That won't work out properly, but
> I'm sure once I actually look at the code I can think of something.

Why it won't work? If you have wext-compat configured, you have the
'wireless' directory (and 'ieee80211' as well). If you don't have
wext-compat, you don't have the 'wireless' directory. But tools which
depend on wext won't work then anyway, so no difference here.

Or am I missing some special cases?

Thanks,

 Jiri

-- 
Jiri Benc
SUSE Labs

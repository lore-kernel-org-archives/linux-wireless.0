Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:52095 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S964792AbXCPODy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Mar 2007 10:03:54 -0400
Date: Fri, 16 Mar 2007 15:03:52 +0100
From: Jiri Benc <jbenc@suse.cz>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: question: /sys/class/net/*/wireless
Message-ID: <20070316150352.5290eea7@griffin.suse.cz>
In-Reply-To: <1172967669.3402.0.camel@johannes.berg>
References: <1172920691.4966.6.camel@johannes.berg>
	<1172921257.4966.12.camel@johannes.berg>
	<1172967669.3402.0.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 04 Mar 2007 01:21:09 +0100, Johannes Berg wrote:
> On Sat, 2007-03-03 at 12:27 +0100, Johannes Berg wrote:
> > And related to that issue, /proc/net/wireless.
> 
> Actually, that was pointless. I should have checked before, but forgot
> to, /proc/net/wireless lives in wext-common.c now which is compiled
> whenever you have cfg80211/wext-compat and/or wext configured.

Couldn't /sys/class/net/*/wireless be created by wext-common.c as well?
(Didn't check, maybe it's not doable.)

Then we can have /sys/class/net/*/ieee80211 for cfg80211-based
interfaces.

 Jiri

-- 
Jiri Benc
SUSE Labs

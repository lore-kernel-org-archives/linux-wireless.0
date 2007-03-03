Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:48829 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1030666AbXCCPxb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Mar 2007 10:53:31 -0500
Received: from midway.site ([71.245.96.156]) by xenotime.net for <linux-wireless@vger.kernel.org>; Sat, 3 Mar 2007 07:53:27 -0800
Date: Sat, 3 Mar 2007 07:51:19 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: straw poll: new Kconfig symbol for mac80211 debugfs?
Message-Id: <20070303075119.6fe0ae1c.rdunlap@xenotime.net>
In-Reply-To: <1172923924.4966.41.camel@johannes.berg>
References: <1172923924.4966.41.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 03 Mar 2007 13:12:03 +0100 Johannes Berg wrote:

> After moving all the sysfs stuff to debugfs I notice that it is quite a
> large amount of code. Does anybody think having a new Kconfig symbol for
> that like this one
> 
> config MAC80211_DEBUGFS
> 	bool "DebugFS support"
> 	depends on MAC80211
> 	---help---
> 	  Select this to see extensive information about
> 	  the internal state of mac80211 in debugfs.
> 
> 	  Say N unless you know you need this.
> 
> would make sense?

Yes.  But it should also depend on DEBUG_FS... (maybe it does
that somewhere else?)

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

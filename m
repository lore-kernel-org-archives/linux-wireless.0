Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:40770
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030692AbXCCRaG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Mar 2007 12:30:06 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: straw poll: new Kconfig symbol for mac80211 debugfs?
Date: Sat, 3 Mar 2007 18:29:09 +0100
Cc: linux-wireless <linux-wireless@vger.kernel.org>
References: <1172923924.4966.41.camel@johannes.berg>
In-Reply-To: <1172923924.4966.41.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200703031829.09234.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 03 March 2007 13:12, Johannes Berg wrote:
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

I'd say this doesn't make too much sense. Simply enable it
when CONFIG_D80211_DEBUG is set.

-- 
Greetings Michael.

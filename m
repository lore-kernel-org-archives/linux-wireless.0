Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:28113 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096Ab1EFRvU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2011 13:51:20 -0400
Date: Fri, 6 May 2011 10:50:42 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Johannes Berg <johannes.berg@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Linux-Next <linux-next@vger.kernel.org>
Subject: Re: [next] net/mac80211/main.c:700: error: 'const struct
 ieee80211_ops' has no member named 'suspend'
Message-Id: <20110506105042.b873a08e.randy.dunlap@oracle.com> (sfid-20110506_195124_834665_FDB295F8)
In-Reply-To: <BANLkTimMwXVHQtHtgukFvYKcWOuo=tv9ig@mail.gmail.com>
References: <BANLkTimMwXVHQtHtgukFvYKcWOuo=tv9ig@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 6 May 2011 19:39:24 +0200 Geert Uytterhoeven wrote:

> http://kisskb.ellerman.id.au/kisskb/buildresult/4143029/
> 
> net/mac80211/main.c:700: error: 'const struct ieee80211_ops' has no
> member named 'suspend'
> net/mac80211/main.c:700: error: 'const struct ieee80211_ops' has no
> member named 'resume'
> 
> The existence of these two members depends on CONFIG_PM.
> 
> Funny, as both the members and these users were added in the same
> commit eecc48000afe2ca6da22122d553b7cad294e42fc ("mac80211: add basic
> support
> for WoWLAN").

Patch is here:
http://marc.info/?l=linux-wireless&m=130463933324134&w=2

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

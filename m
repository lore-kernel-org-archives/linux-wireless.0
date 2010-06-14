Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:59114 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754078Ab0FNGsk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jun 2010 02:48:40 -0400
Subject: Re: [PATCH 1/3] mac80211: Set basic rates while joining ibss
 network
From: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
To: ext Johannes Berg <johannes@sipsolutions.net>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1276497001.3926.4.camel@jlt3.sipsolutions.net>
References: <1276496145-5623-1-git-send-email-ext-teemu.3.paasikivi@nokia.com>
	 <1276496145-5623-2-git-send-email-ext-teemu.3.paasikivi@nokia.com>
	 <1276497001.3926.4.camel@jlt3.sipsolutions.net>
Content-Type: text/plain
Date: Mon, 14 Jun 2010 09:48:08 +0300
Message-Id: <1276498088.4314.14.camel@paavo-desktop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Mon, 2010-06-14 at 08:30 +0200, ext Johannes Berg wrote:
> On Mon, 2010-06-14 at 09:15 +0300, Teemu Paasikivi wrote:
> > This patch adds support to nl80211 and mac80211 to set basic rates when
> > joining/creating ibss network.
> > 
> > Original patch was posted by Johannes Berg on the linux-wireless posting list.
> 
> Did you actually change it at all? (Ok I see you did make a bugfix, good
> catch)
> 

You're right, I only made that bugfix.


> I personally don't care at all, but I guess generally you should
> attribute it to the person who actually did (most of) the work.
> 
> In any case, John will need this:
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> 

I'm very sorry about forgetting that. I'll send new versions of patches
with appropriate Signed-off-by's.


> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
> 


Teemu



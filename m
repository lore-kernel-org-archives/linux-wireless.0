Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:33690 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763013AbXFHKHZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2007 06:07:25 -0400
Date: Fri, 8 Jun 2007 12:07:32 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>
Subject: Re: [PATCH 1/3] mac80211: add IEEE802.11e/WMM structures
Message-ID: <20070608120732.419332ee@griffin.suse.cz>
In-Reply-To: <1181266477.3039.97.camel@debian.sh.intel.com>
References: <20070606082210.GA28649@mail.intel.com>
	<20070607223058.44122be4@griffin.suse.cz>
	<1181266477.3039.97.camel@debian.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 08 Jun 2007 09:34:37 +0800, Zhu Yi wrote:
> On Thu, 2007-06-07 at 22:30 +0200, Jiri Benc wrote:
> > > +#define SET_TSINFO_SCHEDULE(i, d)	(i.byte3 |= (d << 0) & 0x01)
> > 
> > Please add IEEE80211_ prefix here as well. For consistency and not
> > polluting a name space.
> 
> Point accepted.

Thanks :-)

> I think we have talked this early and now you know correctly WIFI is not
> a trademark. You define IEEE80211_STYPE_ASSOC_REQ, etc, but defines
> those for Wi-Fi with WLAN prefix? WLAN prefix should be used by symbols
> defined by mac80211, for example: WLAN_CAPABILITY_ESS.

You and Jouni are right, WLAN_ is used for IEEE 802.11 stuff. So
another prefix makes sense here. And I realized my other comment wasn't
meaningful too, as also IEEE 802.11 is a trademark. ACK for those
names, thanks for the clarification.

 Jiri

-- 
Jiri Benc
SUSE Labs

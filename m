Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:58166 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1767895AbXEDLA3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 May 2007 07:00:29 -0400
Date: Fri, 4 May 2007 13:00:19 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>
Subject: Re: [PATCH V3] mac80211: Add support for SIOCGIWRATE ioctl to  provide rate information
Message-ID: <20070504130019.2f0911ca@griffin.suse.cz>
In-Reply-To: <1178276312.7408.9.camel@johannes.berg>
References: <463a8a92.jFmmjY4cDnfJeisJ%Larry.Finger@lwfinger.net>
	<1178276312.7408.9.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 04 May 2007 12:58:32 +0200, Johannes Berg wrote:
> Is this racy if somebody changes the type of the interface at the same
> time? Would a fix be to sta_info_get() beforehand? I really don't know
> without digging the code, Jiri, Michael?

It's under rtnl, so that's fine.

 Jiri

-- 
Jiri Benc
SUSE Labs

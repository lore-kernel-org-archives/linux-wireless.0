Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:59964 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933103Ab0E0I12 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 May 2010 04:27:28 -0400
Subject: Re: [PATCHv2] mac80211: Fix basic rates for created IBSS networks
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Johannes Berg <johannes@sipsolutions.net>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1274947895.3669.16.camel@jlt3.sipsolutions.net>
References: <1274878088-22785-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1274878391.3658.9.camel@jlt3.sipsolutions.net>
	 <1274879624.5277.1917.camel@wimaxnb.nmp.nokia.com>
	 <1274883276.3658.15.camel@jlt3.sipsolutions.net>
	 <1274936780.5277.2879.camel@wimaxnb.nmp.nokia.com>
	 <1274947895.3669.16.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 May 2010 11:28:29 +0300
Message-ID: <1274948909.5277.3105.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-05-27 at 10:11 +0200, ext Johannes Berg wrote:
> On Thu, 2010-05-27 at 08:06 +0300, Juuso Oikarinen wrote:
> > On Wed, 2010-05-26 at 16:14 +0200, ext Johannes Berg wrote:
> > > TBD
> > > 
> > > Needs to be split up (setting bss_conf and the bss_change flag is a
> > > separate bugfix) and tested but this is what I think it should be like.
> > 
> > Yes, I think this would work. Are you planning on working on this patch?
> 
> No.

Okay, I'll take the patch and work it further.

-Juuso

> johannes
> 



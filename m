Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43391 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754902Ab0E0ILl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 May 2010 04:11:41 -0400
Subject: Re: [PATCHv2] mac80211: Fix basic rates for created IBSS networks
From: Johannes Berg <johannes@sipsolutions.net>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1274936780.5277.2879.camel@wimaxnb.nmp.nokia.com>
References: <1274878088-22785-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1274878391.3658.9.camel@jlt3.sipsolutions.net>
	 <1274879624.5277.1917.camel@wimaxnb.nmp.nokia.com>
	 <1274883276.3658.15.camel@jlt3.sipsolutions.net>
	 <1274936780.5277.2879.camel@wimaxnb.nmp.nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 May 2010 10:11:35 +0200
Message-ID: <1274947895.3669.16.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-05-27 at 08:06 +0300, Juuso Oikarinen wrote:
> On Wed, 2010-05-26 at 16:14 +0200, ext Johannes Berg wrote:
> > TBD
> > 
> > Needs to be split up (setting bss_conf and the bss_change flag is a
> > separate bugfix) and tested but this is what I think it should be like.
> 
> Yes, I think this would work. Are you planning on working on this patch?

No.

johannes


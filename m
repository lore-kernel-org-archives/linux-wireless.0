Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40300 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755820Ab0KKUE5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Nov 2010 15:04:57 -0500
Subject: Re: [PATCH] cfg80211/mac80211: allow per-station GTKs
From: Johannes Berg <johannes@sipsolutions.net>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20101111210824.685154i2r52oacqo@hayate.sektori.org>
References: <1286300370.3641.17.camel@jlt3.sipsolutions.net>
	 <20101111210824.685154i2r52oacqo@hayate.sektori.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Nov 2010 12:06:17 -0800
Message-ID: <1289505977.3695.6.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-11-11 at 21:08 +0200, Jussi Kivilinna wrote:
> Quoting "Johannes Berg" <johannes@sipsolutions.net>:
> 
> > @@ -1312,6 +1314,7 @@ enum wiphy_flags {
> >  	WIPHY_FLAG_4ADDR_AP			= BIT(5),
> >  	WIPHY_FLAG_4ADDR_STATION		= BIT(6),
> >  	WIPHY_FLAG_CONTROL_PORT_PROTOCOL	= BIT(7),
> > +	WIPHY_FLAG_IBSS_RSN			= BIT(7),
> >  };
> 
> This should be BIT(8), right?

Crap, yes, of course. I guess this overlapped with the patch that added
the control port stuff. Since it's already merged, do you want to send a
fixup?

johannes


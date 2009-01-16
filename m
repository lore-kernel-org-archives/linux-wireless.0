Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:47359 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754464AbZAPQm6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2009 11:42:58 -0500
Received: from mail.atheros.com ([10.10.20.107])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 16 Jan 2009 08:42:58 -0800
Date: Fri, 16 Jan 2009 08:42:29 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 04/13] cfg80211: export freq_reg_info()
Message-ID: <20090116164229.GI29609@tesla> (sfid-20090116_174303_508103_B939E7C5)
References: <1232065614-18007-1-git-send-email-lrodriguez@atheros.com> <1232097266.3854.11.camel@johannes>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1232097266.3854.11.camel@johannes>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 16, 2009 at 01:14:26AM -0800, Johannes Berg wrote:
> On Thu, 2009-01-15 at 16:26 -0800, Luis R. Rodriguez wrote:
> 
> > @@ -846,29 +846,9 @@ static int freq_reg_info_regd(struct wiphy *wiphy, u32 center_freq,
> >  
> >  	return !max_bandwidth;
> >  }
> > +EXPORT_SYMBOL(freq_reg_info);
> 
> that kinda seems to be in the wrong spot.

Ah yeah, but it still works, sure I'll fix, good catch.

> I also don't quite understand what you need this for?

Did you read the ath9k patch?

  Luis

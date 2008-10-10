Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40241 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763072AbYJJVjE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2008 17:39:04 -0400
Date: Fri, 10 Oct 2008 17:36:10 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] nl80211: export HT capabilities
Message-ID: <20081010213610.GB20509@tuxdriver.com> (sfid-20081010_233918_091338_378B47BE)
References: <1223547613.22490.41.camel@johannes.berg> <20081009085747.GB11530@tesla> <1223630622.17594.0.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1223630622.17594.0.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 10, 2008 at 11:23:42AM +0200, Johannes Berg wrote:
> On Thu, 2008-10-09 at 01:57 -0700, Luis R. Rodriguez wrote:
> > On Thu, Oct 09, 2008 at 03:20:13AM -0700, Johannes Berg wrote:
> > > +#define NL80211_BAND_ATTR_HT_CAPA NL80211_BAND_ATTR_HT_CAPA
> > 
> > Typo
> 
> Hmm? Am I too dense?

Well, it looks a little useless to define something as itself...

-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.

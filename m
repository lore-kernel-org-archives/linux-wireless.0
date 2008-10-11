Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:43315 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753228AbYJKQfU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Oct 2008 12:35:20 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] nl80211: export HT capabilities
Date: Sat, 11 Oct 2008 18:34:46 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <1223547613.22490.41.camel@johannes.berg> <1223630622.17594.0.camel@johannes.berg> <20081010213610.GB20509@tuxdriver.com>
In-Reply-To: <20081010213610.GB20509@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200810111834.46391.mb@bu3sch.de> (sfid-20081011_183526_831333_1D217BB4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 10 October 2008 23:36:10 John W. Linville wrote:
> On Fri, Oct 10, 2008 at 11:23:42AM +0200, Johannes Berg wrote:
> > On Thu, 2008-10-09 at 01:57 -0700, Luis R. Rodriguez wrote:
> > > On Thu, Oct 09, 2008 at 03:20:13AM -0700, Johannes Berg wrote:
> > > > +#define NL80211_BAND_ATTR_HT_CAPA NL80211_BAND_ATTR_HT_CAPA
> > > 
> > > Typo
> > 
> > Hmm? Am I too dense?
> 
> Well, it looks a little useless to define something as itself...
> 

No, it's a cpp trick. You can use #ifdef to find out whether something is
implemented or not.

-- 
Greetings Michael.

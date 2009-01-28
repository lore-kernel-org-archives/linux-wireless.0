Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:12118 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751095AbZA1Sx1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2009 13:53:27 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 28 Jan 2009 10:53:27 -0800
Date: Wed, 28 Jan 2009 10:52:35 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] cfg80211: add get reg command
Message-ID: <20090128185235.GC26656@tesla> (sfid-20090128_195330_487814_7A5A164F)
References: <1233161043-26721-1-git-send-email-lrodriguez@atheros.com> <1233168462.4811.13.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1233168462.4811.13.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 28, 2009 at 10:47:42AM -0800, Johannes Berg wrote:
> On Wed, 2009-01-28 at 08:44 -0800, Luis R. Rodriguez wrote:
> 
> > +/* caller is reponsible for locking while accessing this */
> > +const struct ieee80211_regdomain *reg_get_current_rd(void)
> > +{
> > +	return cfg80211_regdomain;
> > +}
> 
> why not make the symbol cfg80211_regdomain non-static and use it
> directly?

Its only accessed once, but sure, OK.

  Luis

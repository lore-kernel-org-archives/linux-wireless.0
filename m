Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:32555 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752778AbZAMWvi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2009 17:51:38 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 13 Jan 2009 14:51:38 -0800
Date: Tue, 13 Jan 2009 14:51:13 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 07/12] cfg80211: allow driver read access to
	cfg80211_regdomain
Message-ID: <20090113225112.GT4416@tesla> (sfid-20090113_235141_419840_0B0BDFF6)
References: <1231876675-20518-1-git-send-email-lrodriguez@atheros.com> <1231876675-20518-2-git-send-email-lrodriguez@atheros.com> <1231876675-20518-3-git-send-email-lrodriguez@atheros.com> <1231876675-20518-4-git-send-email-lrodriguez@atheros.com> <1231876675-20518-5-git-send-email-lrodriguez@atheros.com> <1231876675-20518-6-git-send-email-lrodriguez@atheros.com> <1231876675-20518-7-git-send-email-lrodriguez@atheros.com> <1231876675-20518-8-git-send-email-lrodriguez@atheros.com> <1231886819.3728.2.camel@johannes>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1231886819.3728.2.camel@johannes>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 13, 2009 at 02:46:59PM -0800, Johannes Berg wrote:
> On Tue, 2009-01-13 at 11:57 -0800, Luis R. Rodriguez wrote:
> > A driver's reg_notfier() may want to inspect the currently set
> > regulatory domain.
> 
> > +const struct ieee80211_regdomain *cfg80211_regdomain;
> > +EXPORT_SYMBOL(cfg80211_regdomain);
> 
> Can't we just pass it to the notifier instead of exporting it?

I as thinking about that too, sure, either or is fine. Any preference?

  Luis

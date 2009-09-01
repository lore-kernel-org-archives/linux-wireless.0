Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:11453 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754745AbZIAPre (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2009 11:47:34 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 01 Sep 2009 08:47:37 -0700
Date: Tue, 1 Sep 2009 08:47:35 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 3/7] wireless: update cfg80211 kconfig entry
Message-ID: <20090901154735.GC8261@mosca>
References: <1251818566-9264-1-git-send-email-lrodriguez@atheros.com>
 <1251818566-9264-4-git-send-email-lrodriguez@atheros.com>
 <4A9D3FA8.9020800@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4A9D3FA8.9020800@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 01, 2009 at 08:37:12AM -0700, Larry Finger wrote:
> Luis R. Rodriguez wrote:
> > cfg80211 is now *the* wireless configuration API. Lets also
> > give a little explanation as to what it is and refer people to
> > the wireless wiki for more information.
> >
> > Cc: Johannes Berg <johannes@sipsolutions.net>
> > Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> > ---
> >  net/wireless/Kconfig |   11 ++++++++++-
> >  1 files changed, 10 insertions(+), 1 deletions(-)
> >
> > diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
> > index aea7e68..9fd570b 100644
> > --- a/net/wireless/Kconfig
> > +++ b/net/wireless/Kconfig
> > @@ -1,6 +1,15 @@
> >  config CFG80211
> > -     tristate "Improved wireless configuration API"
> > +     tristate "cfg80211 - wireless configuration API"
> >       depends on RFKILL || !RFKILL
> > +     ---help---
> > +       cfg80211 is the Linux wireless LAN (802.11) configuration API.
> > +       Enable this if you have a wireless device.
> > +
> > +       For more information refer to documentation on the wireless wiki:
> > +
> > +       http://wireless.kernel.org/en/developers/Documentation/cfg80211
> > +
> > +       When built as a module cfg80211 will be built as cfg80211
> 
> First of all, I think this modest change is much better than the
> previous set of patches, and that the additional info you provide for
> mac80211 and friends will be useful for those who don't live with
> 802.11 wifi all day long.
> 
> That said, I find the above statement to be a little clumsy. Perhaps
> it should be "When built as a module, it will be called cfg80211". The
> same comment also applies to patch 6 for mac80211.

Thanks, will resend.

  Luis

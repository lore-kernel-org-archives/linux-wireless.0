Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43092 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968Ab2GKOaf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jul 2012 10:30:35 -0400
Message-ID: <1342017031.4464.5.camel@jlt3.sipsolutions.net> (sfid-20120711_163038_950723_18A08275)
Subject: Re: warning in iwlwifi on monitor mode in 3.5.0-rc6-wl
From: Johannes Berg <johannes@sipsolutions.net>
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Date: Wed, 11 Jul 2012 16:30:31 +0200
In-Reply-To: <CAD2nsn3j4TeopXJtsGACpie6oxo1U+8vYtdv8h65t9jdgqRk1Q@mail.gmail.com> (sfid-20120711_162902_749311_ED39783B)
References: <CAD2nsn2Yya-Xi5k55WZVHg6PU5ahRnKqzOPHit8BRNzgSE1vuQ@mail.gmail.com>
	 <1342016326.4464.4.camel@jlt3.sipsolutions.net>
	 <CAD2nsn2JrWd4qo_ELZbTmkU_EcL6YFL3x3rmssh_SrF88UXS_g@mail.gmail.com>
	 <CAD2nsn3j4TeopXJtsGACpie6oxo1U+8vYtdv8h65t9jdgqRk1Q@mail.gmail.com>
	 (sfid-20120711_162902_749311_ED39783B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-07-11 at 19:59 +0530, Mohammed Shafi wrote:
> On Wed, Jul 11, 2012 at 7:54 PM, Mohammed Shafi
> <shafi.wireless@gmail.com> wrote:
> > On Wed, Jul 11, 2012 at 7:48 PM, Johannes Berg
> > <johannes@sipsolutions.net> wrote:
> >> This isn't really related to iwlwifi...
> >>
> >> Looks like this might be due to Michal's changes, maybe the monitor
> >> callback is coming too early?
> >
> > ath9k got bailed out of drv_add_interface as this flag
> > IEEE80211_HW_WANT_MONITOR_VIF
> > was not supported
> 
> Johannes, i had put few manual prints in mac80211 for something else, if you
> want i can a give fresh call trace with proper function offsets.

Shouldn't be needed, no worries.

johannes


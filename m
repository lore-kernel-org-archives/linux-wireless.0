Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58380 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751056AbcIPJbd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Sep 2016 05:31:33 -0400
Message-ID: <1474018288.5481.4.camel@sipsolutions.net> (sfid-20160916_113136_815316_C21213F1)
Subject: Re: wireless.wiki.kernel.org: lingering status of
 http://linuxwireless.org/en/users/Drivers/wl12xx/calibrator/
From: Johannes Berg <johannes@sipsolutions.net>
To: Andreas Mohr <andi@lisas.de>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 16 Sep 2016 11:31:28 +0200
In-Reply-To: <20160915151437.GA24991@rhlx01.hs-esslingen.de>
References: <20160915151437.GA24991@rhlx01.hs-esslingen.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> since we are working with TI WL12xx hardware,
> I keep a reference on
> http://linuxwireless.org/en/users/Drivers/wl12xx/calibrator/ ,
> where it now says:
> "NOTE: this page is for archival only, see the note at the end of the
> page."
> "This is a static dump of the old wiki, taken after locking it in
> January 2015. The new wiki is at https://wireless.wiki.kernel.org/."

Indeed, we migrated the wiki to new infrastructure hosted on kernel.org
back then.

> Trying to find related information by searching for "calibrator" on
> https://wireless.wiki.kernel.org will yield
> https://wireless.wiki.kernel.org/en/developers/documentation/nl80211?
> s[]=calibrator where "wl12xx calibrator" is a *dead link*.
> The apparent underlying reason for this surfaces when going through
> the en ... users ... Drivers hierarchy to
> https://wireless.wiki.kernel.org/en/users/drivers/wl12xx
> where it says
> "
> For relicensing, the content of this page was removed.
> 
> The old website for now has a copy of the old content:
> 
> http://linuxwireless.sipsolutions.net/en/users/Drivers/wl12xx/·
> "

Right, so there were some people who couldn't be reached for
relicensing of their submissions under the license the new wiki
requires. The wl1251 and wl12xx pages were removed since I couldn't
reach Gery Kahn and Oz Krakowski, or they couldn't agree to
relicensing, I don't remember. I still have the Google spreadsheet that
tells me who it was though :-)

> Somehow I am not quite feeling entirely well with this status quo
> (I would expect that that content *will* get lost, and possibly
> rather sooner than later, since someone is bound to eventually say
> "the old site copy is not needed any more").

I have no intention of removing it, since it's a static HTML site and
has no maintenance overhead.

> So, are there some ways to improve the content situation,
> or will this job then eventually need to be done by last-ditch
> efforts (web.archive.org etc.)?

I can't side-step the licensing issue, so no. You can download and
store locally everything you need, I guess.

johannes

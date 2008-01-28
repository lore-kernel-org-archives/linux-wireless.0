Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4285 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751970AbYA1Pf2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2008 10:35:28 -0500
Date: Mon, 28 Jan 2008 10:12:00 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: stefano.brivio@polimi.it, Larry Finger <Larry.Finger@lwfinger.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: mac80211 crash in ieee80211_sta_scan_work
Message-ID: <20080128151200.GC5835@tuxdriver.com> (sfid-20080128_153551_402206_1FD08A4D)
References: <479D9B5F.5000304@lwfinger.net> <1ba2fa240801280129g5c9c7b73pdfdb2eb80944ce32@mail.gmail.com> <20080128103739.oi3iwmmzlwo8w4gw@webmail.polimi.it> <1ba2fa240801280148r27fac26ep5403bc8ccfc6d37a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1ba2fa240801280148r27fac26ep5403bc8ccfc6d37a@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 28, 2008 at 11:48:51AM +0200, Tomas Winkler wrote:
> On Jan 28, 2008 11:37 AM,  <stefano.brivio@polimi.it> wrote:
> > Quoting Tomas Winkler <tomasw@gmail.com>:
> >
> > > There are too many issues with API change patch. I think it is a good
> > > direction but it's really unstable I think we need to give another
> > > round before it can be applied.
> >
> > That has already been applied. I suggest that you point out the
> > iwl4965 bugs you generically reported so that they can be fixed as well.
> >
> We've seen already patches to be un-applied, reverted.
> I'll fix the bugs that's not problem but it takes time. I'm just
> worried about the other users that find driver unusable.

I'm going to hold it back from 2.6.25.  We can work on it for 2.6.26.

John
-- 
John W. Linville
linville@tuxdriver.com

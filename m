Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:56028 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbYA1PUn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2008 10:20:43 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: mac80211 crash in ieee80211_sta_scan_work
Date: Mon, 28 Jan 2008 16:18:56 +0100
Cc: stefano.brivio@polimi.it,
	"Larry Finger" <Larry.Finger@lwfinger.net>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"John Linville" <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
References: <479D9B5F.5000304@lwfinger.net> <20080128103739.oi3iwmmzlwo8w4gw@webmail.polimi.it> <1ba2fa240801280148r27fac26ep5403bc8ccfc6d37a@mail.gmail.com>
In-Reply-To: <1ba2fa240801280148r27fac26ep5403bc8ccfc6d37a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200801281618.56891.mb@bu3sch.de> (sfid-20080128_152047_302014_0DDAE6D3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 28 January 2008 10:48:51 Tomas Winkler wrote:
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

We are inside of a development kernel cycle. So where's the actual problem?
People should get kicked ass for assuming a dev kernel was stable. ;)

-- 
Greetings Michael.

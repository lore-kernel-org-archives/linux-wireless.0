Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:45289 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697AbYA1Smh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2008 13:42:37 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: mac80211 crash in ieee80211_sta_scan_work
Date: Mon, 28 Jan 2008 19:39:40 +0100
Cc: Larry Finger <larry.finger@lwfinger.net>,
	Tomas Winkler <tomasw@gmail.com>, stefano.brivio@polimi.it,
	Johannes Berg <johannes@sipsolutions.net>,
	wireless <linux-wireless@vger.kernel.org>
References: <479D9B5F.5000304@lwfinger.net> <479E14FA.2010206@lwfinger.net> <20080128181900.GF5835@tuxdriver.com>
In-Reply-To: <20080128181900.GF5835@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200801281939.40885.mb@bu3sch.de> (sfid-20080128_184240_026471_FE8A45CA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 28 January 2008 19:19:00 John W. Linville wrote:
> On Mon, Jan 28, 2008 at 10:46:34AM -0700, Larry Finger wrote:
> > Michael Buesch wrote:
> >> On Monday 28 January 2008 16:12:00 John W. Linville wrote:
> >>> I'm going to hold it back from 2.6.25.  We can work on it for 2.6.26.
> 
> >> Please apply this patch and apply fixes inside of the 2.6.25 development
> >> cycle. We are in a _development_ kernel. Kernels _do_ break in development
> >> stages. That is the whole reason why development kernels exist.
> 
> > I agree with Michael on this issue. Due to the uncertainty of the quality 
> > of my Internet connection this winter, I no longer subscribe to 
> > linux-wireless, and I'm not sure of all the discussion that went into the 
> > API change. I have, however, seen the FIXME's in b43. In addition, getting 
> > the code into 2.6.25-rc1 will get a lot more testers.
> 
> I think you guys are missing a couple of points...
> 
> One is that the 2.6.25 development cycle is closed.  The merge window
> is now open and when it closes the stabilization period will begin,
> leading until the release of 2.6.25 in several weeks or 2-3 months.
> Ideally any patches sent in the merge window should already have spent
> time in the -mm tree.  While that isn't always strictly enforced,
> it does imply that huge patches with known breakages and unknown
> remedies are not entirely welcome. :-)
> 
> The other point is that I am happy to keep this API change in
> the wireless-2.6 tree for the 2.6.26 development cycle (which has

While I still completely disagree with you, I'm happy that you will
be handling all maintaining, merging, porting and stuff that will be
needed then.
So I'm OK with that, as long as I don't have to worry about porting
stuff around (and I will _not_ port stuff that depends on the new API
to the old API. Even bugfixes. Somebody else please do that then).

-- 
Greetings Michael.

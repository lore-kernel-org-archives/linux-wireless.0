Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:56625 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752605AbYI2R3n (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Sep 2008 13:29:43 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 29 Sep 2008 10:29:43 -0700
Date: Mon, 29 Sep 2008 10:29:30 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Steven Noonan <steven@uplinklabs.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"yi.zhu@intel.com" <yi.zhu@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC V3] mac80211: re-enable aggregation on 2.6.27
Message-ID: <20080929172930.GB6203@tesla> (sfid-20080929_192949_095753_D0323CCF)
References: <1222371297-24498-1-git-send-email-tomas.winkler@intel.com> <f488382f0809251243x472ff579n8ada22e8f7110aae@mail.gmail.com> <20080926015100.GR6204@tesla> <f488382f0809251945u3eb1f0bdgfe8587e8c103b009@mail.gmail.com> <f488382f0809271949j3c39a1aag8a57b1cb03a5c001@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <f488382f0809271949j3c39a1aag8a57b1cb03a5c001@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Sep 27, 2008 at 07:49:06PM -0700, Steven Noonan wrote:
> On Thu, Sep 25, 2008 at 7:45 PM, Steven Noonan <steven@uplinklabs.net> wrote:
> > On Thu, Sep 25, 2008 at 6:51 PM, Luis R. Rodriguez <lrodriguez@atheros.com> wrote:
> >>
> >> Please test and let us know, try HT40 on 11a. We're keen on resolving
> >> this just as with the MIB interrupt issue you say ;)
> >
> > Will do. It will have to wait until Monday though, because I stupidly
> > left my AirPort Extreme router's AC adapter at home (3 hours away).
> 
> I just realized I happened to have a Linksys WRT300N router with me
> (completely forgot I even owned one). Anyway, I'm running with HT40,
> and it seems to work fine. Throughput is certainly lower than on Mac
> OS X (I get about 8 megabytes per second sustained transfer rate on OS
> X), as I'm only getting about 2 megabytes per second with ath9k on
> Linux.  The aggregation patch does make a difference, but not by a
> whole lot.

We will work on resolving throughput issues, check out wireless-testing
with the patches too (they haven't yet been merged), see if you see
improvements there.

For now we want to just fix 2.6.27 to have aggregation available.

  Luis

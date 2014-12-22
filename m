Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33515 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754281AbaLVNOj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Dec 2014 08:14:39 -0500
Message-ID: <1419254074.1890.18.camel@sipsolutions.net> (sfid-20141222_141442_020873_C94AE707)
Subject: Re: [PATCH 1/2] brmc80211: dont use jiffies for BSS TSF
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: Franky Lin <frankyl@broadcom.com>, linux-wireless@vger.kernel.org
Date: Mon, 22 Dec 2014 14:14:34 +0100
In-Reply-To: <549818FE.1090707@broadcom.com>
References: <20120313125702.703540202@sipsolutions.net>
		 <20120313125919.370791280@sipsolutions.net>
		 (sfid-20120313_140421_642123_6BC8E250) <1419253089.1890.13.camel@sipsolutions.net>
	 <549818FE.1090707@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-12-22 at 14:13 +0100, Arend van Spriel wrote:
> On 12/22/14 13:58, Johannes Berg wrote:
> > By the way - I know now that the proprietary Broadcom driver has the
> > same bug, to the point where this is apparently getting encoded into the
> > Android framework.
> >
> > I urge you to fix this issue there as well. If an absolute "last
> > updated" timestamp is needed (and "last seen [ms] ago" isn't sufficient)
> > then new API will be needed.
> 
> Sorry, seem to have missed the original patches somehow. Guess because 
> it says *brmc*80211.

No no - it's a looong time ago and was also applied a long time ago. It
just reared it's head again in another place.

johannes


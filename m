Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39757 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187Ab1BAOw4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Feb 2011 09:52:56 -0500
Subject: Re: [PATCH] mac80211: pass up beacons from external BSS when
 operating as AP
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: Arik Nemtsov <arik@wizery.com>, linux-wireless@vger.kernel.org
In-Reply-To: <20110201145100.GA21686@jm.kir.nu>
References: <1296559385-5357-1-git-send-email-arik@wizery.com>
	 <1296568614.3989.6.camel@jlt3.sipsolutions.net>
	 <20110201145100.GA21686@jm.kir.nu>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Feb 2011 15:52:53 +0100
Message-ID: <1296571973.3989.10.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-02-01 at 16:51 +0200, Jouni Malinen wrote:
> On Tue, Feb 01, 2011 at 02:56:54PM +0100, Johannes Berg wrote:
> > On Tue, 2011-02-01 at 13:23 +0200, Arik Nemtsov wrote:
> > > Beacons from external BSSes are required for updating overlapping BSS
> > > info (i.e. ERP protection). Pass them up unconditionally.
> > 
> > Where will they be processed though?
> 
> In src/ap/ap_list.c (hostap.git) ;-)
> 
> This code has been there for a long time, but the functionality was
> broken at some point (maybe already during d80211 -> mac80211 process)
> due to the beacons not getting delivered there anymore.

Oh, I guess then they are delivered via the monitor interface?

johannes


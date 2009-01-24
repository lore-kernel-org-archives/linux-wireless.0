Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:49026 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755185AbZAXUjO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jan 2009 15:39:14 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sat, 24 Jan 2009 12:39:14 -0800
Date: Sat, 24 Jan 2009 12:38:36 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Alina Friedrichsen <x-alina@gmx.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Subject: Re: [PATCH] mac80211: Generic TSF debugging
Message-ID: <20090124203836.GC22475@tesla> (sfid-20090124_213917_189844_00812097)
References: <20090124060959.50440@gmx.net> <1232806359.4036.3.camel@johannes.local> <1232807228.4036.12.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1232807228.4036.12.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 24, 2009 at 06:27:08AM -0800, Johannes Berg wrote:
> On Sat, 2009-01-24 at 15:12 +0100, Johannes Berg wrote:
> > On Sat, 2009-01-24 at 07:09 +0100, Alina Friedrichsen wrote:
> > > This patch enables low-level driver independent debugging of the TSF
> > > and remove the driver specific things of ath5k and ath9k from the
> > > debugfs.
> > 
> > NACK.
> > 
> > You still haven't explained why you need set_tsf support and why it
> > should be a generic mac80211 functionality.
> 
> Ok, I guess you have, I'm still not sure it's the best approach.
> 
> Other opinions?

Seems reasonable to me instead of having different drivers implement different
APIs/debugfs solutions.

  Luis

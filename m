Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:19414 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973AbZBXC25 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2009 21:28:57 -0500
Received: from mail.atheros.com ([10.10.20.107])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 23 Feb 2009 18:28:56 -0800
Date: Mon, 23 Feb 2009 18:28:12 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v6 00/15] cfg80211: add a workqueue for regulatory
	processing
Message-ID: <20090224022812.GJ4264@tesla> (sfid-20090224_032900_776678_41B35B05)
References: <1235192673-6314-1-git-send-email-lrodriguez@atheros.com> <1235440617.4455.47.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1235440617.4455.47.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 23, 2009 at 05:56:57PM -0800, Johannes Berg wrote:
> On Sat, 2009-02-21 at 00:04 -0500, Luis R. Rodriguez wrote:
> > I found one bug in my v5 series on the workqueue patch -- I was
> > accessing wiphy->custom_regulatory without first checking if the
> > wiphy existed, in case there are any conflicts I am rebasing the
> > other patches and just sending a new version 6 series.
> 
> Did anything else significantly change? I gave it a quick look and it
> seems fine.

Nope, just one line where I forgot to check for wiphy first before checking
for wiphy->custom_regulatory.

  Luis

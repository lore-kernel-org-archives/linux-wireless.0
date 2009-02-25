Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:52219 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752836AbZBYBy2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2009 20:54:28 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 24 Feb 2009 17:54:26 -0800
Date: Tue, 24 Feb 2009 17:53:42 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] cfg80211: unregister ml groups on failure
Message-ID: <20090225015342.GB22710@tesla> (sfid-20090225_025431_096652_A15EF995)
References: <1235524450-22624-1-git-send-email-lrodriguez@atheros.com> <1235526282.28635.0.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1235526282.28635.0.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 24, 2009 at 05:44:42PM -0800, Johannes Berg wrote:
> On Tue, 2009-02-24 at 17:14 -0800, Luis R. Rodriguez wrote:
> > We were not doing so before.
> 
> and we don't need to, they get removed with the family automatically.

Oh, nice, I figured that was a chance but thought it would have been too
good to be true.

  Luis

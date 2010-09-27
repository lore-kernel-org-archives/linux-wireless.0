Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34677 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756897Ab0I0SUc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 14:20:32 -0400
Subject: Re: [RFC] mac80211: fix release_reorder_timeout in scan
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: wireless <linux-wireless@vger.kernel.org>, Jouni Malinen <j@w1.fi>,
	Christian Lamparter <chunkeey@googlemail.com>
In-Reply-To: <AANLkTi=3GraBb9hTrieCNvCB0o3PXGORkW1b7F2PceK3@mail.gmail.com>
References: <1285266471.3770.384.camel@jlt3.sipsolutions.net>
	 <AANLkTi=3GraBb9hTrieCNvCB0o3PXGORkW1b7F2PceK3@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Sep 2010 20:20:30 +0200
Message-ID: <1285611630.4043.26.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-09-27 at 11:14 -0700, Luis R. Rodriguez wrote:
> On Thu, Sep 23, 2010 at 11:27 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> >
> > Even if the reorder timeout timer fires while
> > scanning, the frames weren't received during
> > scanning and therefore shouldn't be dropped.
> 
> I don't get what we are doing with these frames today, are you saying
> we pegged some of these frames into the reorder buffer when starting a
> sw scan, or that we were dropping them?

You keep confusing TX and RX ... ;)

This is all about RX only.

johannes


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34061 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757733Ab0FON5A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jun 2010 09:57:00 -0400
Subject: Re: [RFC] Changes in mac80211 to make at76c50x-usb working again
From: Johannes Berg <johannes@sipsolutions.net>
To: Sebastian Smolorz <Sebastian.Smolorz@gmx.de>
Cc: "John W. Linville" <linville@tuxdriver.com>, kalle.valo@iki.fi,
	linux-wireless@vger.kernel.org,
	Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <201006151549.41963.Sebastian.Smolorz@gmx.de>
References: <201006151416.36686.Sebastian.Smolorz@gmx.de>
	 <20100615132619.GB12885@tuxdriver.com>
	 <1276609006.3648.233.camel@jlt3.sipsolutions.net>
	 <201006151549.41963.Sebastian.Smolorz@gmx.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Jun 2010 15:56:51 +0200
Message-ID: <1276610211.3648.234.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-06-15 at 15:49 +0200, Sebastian Smolorz wrote:
> Johannes Berg wrote:
> > On Tue, 2010-06-15 at 09:26 -0400, John W. Linville wrote:
> > > On Tue, Jun 15, 2010 at 02:16:36PM +0200, Sebastian Smolorz wrote:
> > > > Hi,
> > > >
> > > > the at76c50x-usb driver fails to authenticate with an AP.
> > 
> > We need more information on how it fails.
> 
> The problem is that the following if-statement is never true:
> 
> http://lxr.linux.no/#linux+v2.6.34/drivers/net/wireless/at76c50x-usb.c#L1986

That link doesn't work.

johannes


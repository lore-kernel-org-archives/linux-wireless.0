Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:42068 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757802Ab0FOOLP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jun 2010 10:11:15 -0400
From: Sebastian Smolorz <Sebastian.Smolorz@gmx.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC] Changes in mac80211 to make at76c50x-usb working again
Date: Tue, 15 Jun 2010 16:11:56 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>, kalle.valo@iki.fi,
	linux-wireless@vger.kernel.org,
	Marcel Holtmann <marcel@holtmann.org>
References: <201006151416.36686.Sebastian.Smolorz@gmx.de> <201006151549.41963.Sebastian.Smolorz@gmx.de> <1276610211.3648.234.camel@jlt3.sipsolutions.net>
In-Reply-To: <1276610211.3648.234.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201006151611.56061.Sebastian.Smolorz@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Tue, 2010-06-15 at 15:49 +0200, Sebastian Smolorz wrote:
> > Johannes Berg wrote:
> > > On Tue, 2010-06-15 at 09:26 -0400, John W. Linville wrote:
> > > > On Tue, Jun 15, 2010 at 02:16:36PM +0200, Sebastian Smolorz wrote:
> > > > > Hi,
> > > > >
> > > > > the at76c50x-usb driver fails to authenticate with an AP.
> > >
> > > We need more information on how it fails.
> >
> > The problem is that the following if-statement is never true:
> >
> > http://lxr.linux.no/#linux+v2.6.34/drivers/net/wireless/at76c50x-usb.c#L1986
> 
> That link doesn't work.

Hm, for me it works. Alternatively:
http://lxr.free-electrons.com/source/drivers/net/wireless/at76c50x-usb.c#L1986

Anyway, it is line 1986 in drivers/net/wireless/at76c50x-usb.c, kernel version 2.6.34.

-- 
Sebastian

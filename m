Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:33794 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752647AbZAEUPM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2009 15:15:12 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 05 Jan 2009 12:15:12 -0800
Date: Mon, 5 Jan 2009 12:15:09 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Luis Rodriguez <Luis.Rodriguez@Atheros.com>
CC: Joseph Cheek <joseph@cheek.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] 2.6.27 with compat-wireless-2008-12-31 stops
	transmitting every 2-3 minutes
Message-ID: <20090105201509.GI6834@tesla> (sfid-20090105_211518_221992_B47699DB)
References: <495C7640.8060806@cheek.com> <20090105170432.GA6834@tesla> <49624B10.70400@cheek.com> <20090105181250.GD6834@tesla> <496263BC.5020707@cheek.com> <20090105195124.GF6834@tesla>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20090105195124.GF6834@tesla>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 05, 2009 at 11:51:24AM -0800, Luis Rodriguez wrote:
> On Mon, Jan 05, 2009 at 11:47:08AM -0800, Joseph Cheek wrote:
> > Is this page up to date?  I found the latest 802.11n NIC that I could
> > find for my machine...
> >
> > http://wireless.kernel.org/en/users/Drivers/ath9k#ProductsintheretailmarketcontainingAtheros11nsolutions
> >
> > I bought my card after specifically consulting this page.
> 
> Yes.

Just FYI the Bluetooth coexistance stuff seems to be a feature of at least
AR9280 revision 10 and later so if you have an older card than you don't have
BT coexistance, at least from what I can tell.

  Luis

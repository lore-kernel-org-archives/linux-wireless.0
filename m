Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:48018 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161302AbXBGNoZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Feb 2007 08:44:25 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: RFT: The real fix for BCM4311 and BCM4312
Date: Wed, 7 Feb 2007 14:43:19 +0100
Cc: bcm43xx-dev@lists.berlios.de, Pavel Roskin <proski@gnu.org>,
	wireless <linux-wireless@vger.kernel.org>
References: <45C96B8A.8010000@lwfinger.net> <1170830071.11150.62.camel@dv>
In-Reply-To: <1170830071.11150.62.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200702071443.19676.rjw@sisk.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday, 7 February 2007 07:34, Pavel Roskin wrote:
> On Wed, 2007-02-07 at 00:02 -0600, Larry Finger wrote:
> > The patch below will only affect cards with PHY revision 8, which I think are only BCM4311 and
> > BCM4312. At least those are the only ones in the database.
> 
> BCM4312, old patch: 1.7M/s
> no patch: 26k/s
> no patch, rate 1: 100k/s
> new patch: 1.7M/s
> new patch, rate 1: 1.1M/s
> new patch, rate 2: 1.5M/s
> new patch, rate 5.5: 1.7M/s
> new patch, rate 18: 2.2M/s
> new patch, rate 36: 2.2M/s
> 
> Yes, it looks like the new patch is as good as the previous one for my card.

The patch is apparently sufficient for me too.  Moreover, the D-Link APs that
were previously "invisible" are now listed by "iwlist ... scan" and I can
connect with them.  Thanks again!

Greetings,
Rafael

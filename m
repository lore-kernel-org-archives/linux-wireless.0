Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:48960 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752333AbYFZRmv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jun 2008 13:42:51 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Pavel Roskin <proski@gnu.org>
Subject: Re: [Q] ath5k : doesn't support AP mode?
Date: Thu, 26 Jun 2008 18:46:17 +0200
Cc: Stefanik =?iso-8859-15?q?G=E1bor?= <netrolller.3d@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>, cs010101@gmail.com,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
References: <002901c8d737$e51bb2f0$3b0aa8c0@39fb6b6b6f434b3> <200806261821.31643.mb@bu3sch.de> <1214498071.30722.22.camel@dv>
In-Reply-To: <1214498071.30722.22.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200806261846.17962.mb@bu3sch.de> (sfid-20080626_194320_882035_E72DB651)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 26 June 2008 18:34:31 Pavel Roskin wrote:
> On Thu, 2008-06-26 at 18:21 +0200, Michael Buesch wrote:
> > +	  ===> BIG FAT WARNING <===
> > +	  This is not IEEE 802.11 compliant, yet!
> > +	  You might disturb operation of other accesspoints and
> > +	  stations in your neighbourhood. Do only enable this, if
> > +	  you want to help out fixing this to make this warning disappear.
> > +	  If you enable this, expect that your neighbour will ring your
> > +	  door and yell at you for disturbing his network.
> 
> Gladly there will be no black helicopters :-)

Oh right. I forgot these :)

> But is it really so bad?

Well no. But I think we should try hard to make users not use this, yet.
Something that is not IEEE 802.11 compliant is not what everybody should use.
There's enough noise in the air that disturbs wireless. I don't want
to have yet another neighbour installing yet another broken thing. ;)

> What's the current TODO list for the AP mode?

I think there are some issues with the rates.
Maybe more. I don't really know.
I was going to look into this, but I was pushed back a little bit
by some hardware and software defects. I probably need to get new
hardware first.

-- 
Greetings Michael.

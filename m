Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:45291 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965542AbXBFW2E (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Feb 2007 17:28:04 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: bcm43xx-dev@lists.berlios.de,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: RFT bcm43xx: Really _GOOD_ news
Date: Tue, 6 Feb 2007 23:27:16 +0100
Cc: Pavel Roskin <proski@gnu.org>,
	wireless <linux-wireless@vger.kernel.org>,
	Michael Buesch <mb@bu3sch.de>
References: <45C8E64B.1050605@lwfinger.net> <1170800330.2613.10.camel@dv>
In-Reply-To: <1170800330.2613.10.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200702062327.17401.rjw@sisk.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, 6 February 2007 23:18, Pavel Roskin wrote:
> On Tue, 2007-02-06 at 14:34 -0600, Larry Finger wrote:
> > I have really _GOOD_ news!!!!! While reviewing the latest changes in the V4 specs, I found an
> > interchange of the PHY version and PHY revision fields, relative to the current V3 specs. Of the
> > three cards that I have, the 4306 had the same value for the PHY version and revision. In addition,
> > it was the only card of the 3 thaw would work at 11Mbs. A light went on!
> > 
> > After installing the patch listed below, both my 4318 and my 4311 will now run at 11Mbs. From tests
> > with iperf, I now get rates of 6.1 - 6.5 Mbs from all three.
> 
> I'm getting a sustained 1.7 megabytes per second over FTP with 4312
> (PCIe card in Dell Latitude).  The connection to a 802.11g AP was
> established instantaneously.
> 
> I have never had much success with the softmac driver at all.  Now it's
> working better than the d80211 driver, with waits for minutes before it
> starts talking to the same 802.11g AP.
> 
> I think it's a 2.6.20.1 material, considering its gain/changes ratio.
> I'm actually going to compile this kernel without debug and keep it as a
> "production" kernel.
> 
> Congratulations and many many thanks!

I can confirm the driver works great with the patch!

Many thanks, Larry!

Greetings,
Rafael

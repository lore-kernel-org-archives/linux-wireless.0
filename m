Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pne-smtpout2-sn1.fre.skanova.net ([81.228.11.159]:35382 "EHLO
	pne-smtpout2-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753269AbYLHQvD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Dec 2008 11:51:03 -0500
From: "Lars Ericsson" <Lars_Ericsson@telia.com>
To: "'Ivo van Doorn'" <ivdoorn@gmail.com>
Cc: "'Johannes Berg'" <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>
Subject: RE: Monitor number of packages sent and ACK'ed by AP
Date: Mon, 8 Dec 2008 17:50:40 +0100
Message-ID: <0161CC9B2A3341A19CED21A365A90FE4@gotws1589> (sfid-20081208_175108_549316_A694BFCF)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
In-Reply-To: <200812081734.14920.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Monday 08 December 2008, Lars Ericsson wrote:
> > > 
> > > On Mon, 2008-12-08 at 11:50 +0100, Lars Ericsson wrote:
> > > > Hi Johannes,
> > > > 
> > > > I would like to monitor number of packages properly 
> > > transmitted and ACK'ed
> > > > by the AP.
> > > > Is the a single point where this can be done ?
> > > 
> > > Not really, some drivers don't even give you that information,
> > > unfortunately.
> > > 
> > > johannes
> > > 
> > 
> > OK, thanks. 
> > I just discovered that Ralink rt61 does filter all ACK frames.
> > /Lars
> 
> Did you look during monitor mode?
> When monitor mode is not enabled, the RX filter can be quite strict.
> 
> Ivo
> 

Hi Ivo,

No, I did not used monitor mode. I do not know how-to do it.

I have a problem when the STA picks up AP BEACONS (last_rx updated), 
but the AP, due to other AP/STA communication, have problems picking up the
STA traffic.

One idea was to monitor that I receive ACK frames, i.e. someone receives me.
But the driver filter all ACK frames.

Is there any other event generated from the driver to the mac layer that 
can be used indicate bad communication?

For instance large number of retries or low transmition speed.

Regards 
Lars


PS:
You remember the problem we discussed with the PID that did not work, 
until I not forced HW antenna diversity?

I have been monitoring that site for a while and the 2.6.26 driver works
well.
The WLAN is very interesting. It is a http://www.merunetworks.com WLAN where
the STA associates with a virtual AP. The physical AP (radio) varies from
time to 
time depending on the STA location. The STA never noticed when the AP 
is changed since all AP's  uses the same channel and the BSSID is always the
same.

I can explain more if you are interested.

								DS.

//Lars







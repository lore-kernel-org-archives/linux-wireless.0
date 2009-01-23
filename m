Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:47442 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752814AbZAWTG2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 14:06:28 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Dan Williams <dcbw@redhat.com>
Subject: Re: integration of opensource firmware with b43 kernel driver
Date: Fri, 23 Jan 2009 20:05:31 +0100
Cc: bcm43xx-dev@lists.berlios.de,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Francesco Gringoli <francesco.gringoli@ing.unibs.it>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <FF33C500-6653-4A69-B34D-FBE47B2136D3@ing.unibs.it> <200901231908.05835.mb@bu3sch.de> <1232736637.2577.40.camel@localhost.localdomain>
In-Reply-To: <1232736637.2577.40.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200901232005.32048.mb@bu3sch.de> (sfid-20090123_200630_844112_857C8AFD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 23 January 2009 19:50:37 Dan Williams wrote:
> On Fri, 2009-01-23 at 19:08 +0100, Michael Buesch wrote:
> > On Friday 23 January 2009 19:01:00 Larry Finger wrote:
> > > The driver can certainly be coded to look for the open-source firmware
> > > names before trying to load vendor firmware. That way there will not
> > > be any confusion.
> > 
> > I already posted that, but in case you missed it:
> > http://bu3sch.de/patches/wireless-testing/20081227-1821/patches/008-b43-probe-open-fw.patch
> 
> Preferring the proprietary firmware over the open firmware (for now)
> seems like the best approach at this time.  Many people will be quite
> happy with the open firmware that we can actually ship in distros, and
> those that aren't can do the fwcutter stuff and get their own
> proprietary firmware.  If for some reason the open firmware isn't
> working, use fwcutter and get the proprietary firmware, which you would
> have had to do before anyway.  And those people with chips that aren't
> supported by the proprietary firmware yet still have to use the
> fwcutter, which they would have had to do anyway.  Win all around.

Exactly. This is why I implemented it that way.

-- 
Greetings, Michael.

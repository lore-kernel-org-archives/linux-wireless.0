Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm9-vm1.bullet.mail.ird.yahoo.com ([77.238.189.94]:22133 "HELO
	nm9-vm1.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752442Ab2CAOwl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2012 09:52:41 -0500
Message-ID: <1330613559.69118.YahooMailClassic@web29404.mail.ird.yahoo.com> (sfid-20120301_155244_502745_E6639A54)
Date: Thu, 1 Mar 2012 14:52:39 +0000 (GMT)
From: Hin-Tak Leung <hintak_leung@yahoo.co.uk>
Subject: Re: Fw: Google summer of code application for organization opened; wireless projects.
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org,
	Till Kamppeter <till.kamppeter@gmail.com>
In-Reply-To: <20120301105721.GA4560@w1.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--- On Thu, 1/3/12, Jouni Malinen <j@w1.fi> wrote:

> > --- On Tue, 28/2/12, Hin-Tak
> Leung <htl10@users.sourceforge.net>
> wrote:
> > > Came across some android-specific issues
> concerning wifi
> > > support:
> > > http://linuxwireless.org/en/developers/Documentation/Android
> > > 
> > > some of them probably would make a nice GSoC
> project. (using
> > > unmod'ed wpa_supplicant, gui for setting up ad-hoc
> mode,
> > > etc).
> 
> While there are areas that can certainly be improved in
> Android WLAN
> support, please note that this page is quite old and not at
> all accurate
> with the latest Android release (ICS). WEXT has been mostly
> replaced
> with nl80211 and wpa_supplicant is much closer to the
> upstream version.

Argh, both places (the linuxwireless site, and the linux foundation GSoC page) are wiki's... please update with what you know.

The verdicts on the internet seems to be that Android has a slightly modified wpa_supplicant, and also that it is not at all easy to set up ad-hoc mode (even if the hardware/driver supports it). But in any case, make it easier to do Android-Android communication without an AP/intermediate in the middle still seems to be non-trivial, and that can be worked on... it would be a useful thing to do as well, given how many android devices are around these days.

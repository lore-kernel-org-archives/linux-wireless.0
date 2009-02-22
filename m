Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:36314 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753645AbZBVPcU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Feb 2009 10:32:20 -0500
Subject: Re: Signal quality strange since commit 708c57cf1709fb95
From: Dan Williams <dcbw@redhat.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	John Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <8763j33rgq.fsf@litku.valot.fi>
References: <49A01922.1090106@lwfinger.net>
	 <1235241867.3284.44.camel@localhost> <49A05E35.70904@lwfinger.net>
	 <8763j33rgq.fsf@litku.valot.fi>
Content-Type: text/plain
Date: Sun, 22 Feb 2009 10:30:28 -0500
Message-Id: <1235316628.28069.2.camel@localhost> (sfid-20090222_163225_075328_0A42C692)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2009-02-22 at 08:39 +0200, Kalle Valo wrote:
> Larry Finger <Larry.Finger@lwfinger.net> writes:
> 
> > I know how it works with drivers that implement their own ioctl
> > calls for the WEXT interface; however, the 3 that I mentioned all
> > use mac80211 and get their WEXT support through cfg80211.
> 
> Yes, something is wrong now. I noticed the same problem (/70 in signal
> strength) when I was implementing rssi support for at76c50x-usb.

The /70 *by itself* is not a problem.  There could be a problem with the
quality calculation that cfg80211/mac80211 are doing with the reported
signal strength from the hardware-specific driver.

Dan



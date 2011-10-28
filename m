Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54507 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464Ab1J1IEe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Oct 2011 04:04:34 -0400
Subject: Re: cfg80211 events
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: Daniel Wolstenholme <daniel@wolstenholme.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1319756980.4490.6.camel@dcbw.foobar.com> (sfid-20111028_010926_967933_D78AFAE6)
References: <CAB1eQC7cXz0GpGrX7d8_nL_8d8ZAgxSzXUxqDhR7PiSSJysOoQ@mail.gmail.com>
	 <1319756980.4490.6.camel@dcbw.foobar.com>
	 (sfid-20111028_010926_967933_D78AFAE6)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 Oct 2011 10:04:29 +0200
Message-ID: <1319789069.3914.7.camel@jlt3.sipsolutions.net> (sfid-20111028_100438_877593_78B5693E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-10-27 at 18:09 -0500, Dan Williams wrote:
> On Thu, 2011-10-27 at 15:27 -0700, Daniel Wolstenholme wrote:
> > Hi all,
> > 
> > I'm working with the Broadcom brcmfmac driver, and I'm attempting to improve
> > event reporting, but I'm finding there's not that much documentation on
> > wireless events.  One big problem I'm having is that I'm using the cfg80211
> > interface, but when I run "iw event -t -f", I don't see the events showing
> > up.  Another question I have is: is there a way to send events with
> > arbitrary strings from the driver through to userspace?
> 
> I'd be careful of that; we don't want a repeat of IWPRIV events, we'd
> rather have stuff standardized.  Unless you're doing this for testing,
> of course.

Indeed. You can use testmode events for in-house testing, qualification,
calibration, etc. but it will be compiled out in distro kernels.

Arbitrary string events will never exist.

johannes


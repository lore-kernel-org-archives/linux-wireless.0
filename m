Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:46950 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752237AbYCJBAp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Mar 2008 21:00:45 -0400
Subject: Re: [PATCH 00/12] at76_usb mac80211 port
From: Pavel Roskin <proski@gnu.org>
To: Kalle Valo <Kalle.Valo@iki.fi>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <87r6ejyhk2.fsf@litku.valot.fi>
References: <20080210145733.17592.61729.stgit@tikku>
	 <1202706345.20836.26.camel@dv>  <87r6ejyhk2.fsf@litku.valot.fi>
Content-Type: text/plain
Date: Sun, 09 Mar 2008 21:00:43 -0400
Message-Id: <1205110843.2142.37.camel@dv> (sfid-20080310_010049_419061_5ED17C30)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2008-03-09 at 18:43 +0200, Kalle Valo wrote:
> >
> > I've put your patches on http://git.80211libre.org/at76_usb.git so that
> > they can be tested by more users.  I gave no promise about continuity of
> > the branch, so I'm ready to replace the patches.
> 
> Thanks, but it seems that John already applied the patches to
> wireless-testing. I would prefer working directly with
> wireless-testing, because it's easier for me.

That's easier for me too, as 80211libre.org domain is expiring soon.

> > I haven't looked at the code yet, but here are some testing results.
> 
> What hardware and firmware did you use?

The firmware is the latest we support from at76_usb-firmware-0.1.tar.gz
But I don't remember which hardware I was using, as I have several
different devices.  I can test again and provide more details.

> > I'm totally at loss why a positive value us printed. When trying to
> > set the key and ESSID again, I get this:
> >
> > wlan3: Initial auth_alg=0
> > wlan3: authenticate with AP 00:0b:6b:56:01:bf
> > wlan3: authenticate with AP 00:0b:6b:56:01:bf
> > wlan3: authenticate with AP 00:0b:6b:56:01:bf
> > wlan3: authentication with AP 00:0b:6b:56:01:bf timed out
> >
> > Pings don't come through.  Everything is within one room.
> Attenuation
> > shouldn't be an issue.
> 
> Do you mean that all your tries failed? That's bad.

Yes.

> > Another interesting problem - scan results show the channel two
> times
> > (not counting the "frequency" line).  Other mac80211 drivers do it
> once.
> > No idea why.
> 
> Strange. I'll take a look at it as well.

Thanks.

-- 
Regards,
Pavel Roskin

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web51403.mail.re2.yahoo.com ([206.190.38.182]:21114 "HELO
	web51403.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750889AbYGHTuv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jul 2008 15:50:51 -0400
Date: Tue, 8 Jul 2008 12:50:50 -0700 (PDT)
From: Joerg Pommnitz <pommnitz@yahoo.com>
Reply-To: pommnitz@yahoo.com
Subject: Re: Linux capable PDA with WLAN NIC that supports access point mode?
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1215544570.3670.7.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-ID: <493306.38849.qm@web51403.mail.re2.yahoo.com> (sfid-20080708_215054_977950_301ACE2E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > > There's a Broadcom CF card. I have one, but it's
> > > not DMA capable in
> > > Linux because of the PCMCIA subsystem (IIRC).
> > 
> > What driver?
> 
> b43 of course.

But b43 is mac80211 based. This would mean that I had to use your
experimental access point patches, right?

> > 
> > I thought that the Connexant chip in the N810 resembles a FullMAC
> > card. Can this one support AP mode with the standard firmware?
> 
> It's not fullmac.

I stand corrected.


      __________________________________________________________
Gesendet von Yahoo! Mail.
Dem pfiffigeren Posteingang.
http://de.overview.mail.yahoo.com

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web51408.mail.re2.yahoo.com ([206.190.38.187]:25286 "HELO
	web51408.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750804AbYGHT2K convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jul 2008 15:28:10 -0400
Date: Tue, 8 Jul 2008 12:28:08 -0700 (PDT)
From: Joerg Pommnitz <pommnitz@yahoo.com>
Reply-To: pommnitz@yahoo.com
Subject: Re: Linux capable PDA with WLAN NIC that supports access point mode?
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1215544570.3670.7.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-ID: <573701.63380.qm@web51408.mail.re2.yahoo.com> (sfid-20080708_212813_851110_D1BACCBD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--- Johannes Berg <johannes@sipsolutions.net> schrieb am Di, 8.7.2008:

> Von: Johannes Berg <johannes@sipsolutions.net>
> Betreff: Re: Linux capable PDA with WLAN NIC that supports access point mode?
> An: pommnitz@yahoo.com
> CC: linux-wireless@vger.kernel.org
> Datum: Dienstag, 8. Juli 2008, 21:16
> > I know that mac80211 is not there yet, but on the other
> hand
> > OpenWRT seems to run on a lot of hardware with very
> different NICs. How
> > does OpenWRT implement the AP functionality? 
> 
> Either with hostapd or the broadcom proprietary driver.

This is what I suspected, but according to 
http://hostap.epitest.fi/hostapd/ only the following drivers
are supported:

Supported wireless cards/drivers

    * Host AP driver for Prism2/2.5/3
    * madwifi (Atheros ar521x)
    * Prism54.org (Prism GT/Duette/Indigo)
    * BSD net80211 layer (e.g., Atheros driver) (FreeBSD 6-CURRENT)

Looking at the OpenWRT supported hardware list I see a lot of
other NICs. Is the hostapd list incomplete?

> > I'm considering a PCCard based NIC with something
> like the old Compaq iPAQ
> > PC Card Expansion Pack. In this case an Atheros card
> with Madwifi might
> > work. Does this work? Is there a NIC (Broadcom maybe)
> that is better
> > suited?
> > 
> > Is there a CompactFlash based WLAN NIC with an AP
> capable Linux driver?
> 
> There's a Broadcom CF card. I have one, but it's
> not DMA capable in
> Linux because of the PCMCIA subsystem (IIRC).

What driver?

> If you're willing to invest some work, it should be
> possible to get the
> the N810 working with mac80211/p54spi but it's not
> there yet and I don't
> have time to work on it.

I thought that the Connexant chip in the N810 resembles a FullMAC
card. Can this one support AP mode with the standard firmware?

> johannes


      __________________________________________________________
Gesendet von Yahoo! Mail.
Dem pfiffigeren Posteingang.
http://de.overview.mail.yahoo.com

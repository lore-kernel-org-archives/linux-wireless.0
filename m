Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5683 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752710Ab3IEQB0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Sep 2013 12:01:26 -0400
Message-ID: <1378397092.3580.21.camel@dcbw.foobar.com> (sfid-20130905_180135_500254_FA7FE41C)
Subject: Re: Linux Wireless Mini-Summit in New Orleans -- 19-20 September (6
 weeks from today!)
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	marcel@holtmann.org, Samuel Ortiz <samuel@sortiz.org>,
	Gustavo Padovan <gustavo@padovan.org>,
	linux-bluetooth@vger.kernel.org, linux-nfc@ml01.01.org
Date: Thu, 05 Sep 2013 11:04:52 -0500
In-Reply-To: <20130905133907.GE1947@tuxdriver.com>
References: <20130808185410.GD30925@tuxdriver.com>
	 <20130808190428.GF30925@tuxdriver.com>
	 <20130905133907.GE1947@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-09-05 at 09:39 -0400, John W. Linville wrote:
> On Thu, Aug 08, 2013 at 03:04:29PM -0400, John W. Linville wrote:
> > Sorry, forgot to copy linux-bluetooth and linux-nfc...
> > 
> > On Thu, Aug 08, 2013 at 02:54:11PM -0400, John W. Linville wrote:
> > > Greetings!
> > > 
> > > This is a reminder that we will have a Linux Wireless Mini-Summit in
> > > New Orleans this year on 19-20 September.  This will immediately follow
> > > LinuxCon and will run concurrently with Linux Plumber's Conference.
> > > This event includes Linux developers for wireless LAN (802.11),
> > > Bluetooth, and NFC technologies.  Both kernel and userland developers
> > > are welcomed and heartily encouraged to attend!
> > > 
> > > 	http://wireless.kernel.org/en/developers/Summits/New-Orleans-2013
> > > 
> > > The link above is a Wiki.  We are using it to collect discussion
> > > topics and to negotiate agenda/scheduling options for the event.
> > > Please go there to record your intent to attend the event and to
> > > propopse topics for discussion.
> > > 
> > > Please be aware that in order to attend the event above one must
> > > register for either LinuxCon or for Linux Plumbers Conference.
> > > Act now, before those events fill-up and close their registrations!
> > > 
> > > We are allotted one "large" room (up to ~80 people "theater style"), and
> > > two "small" rooms (up to ~25 people) for this event.  Based on history
> > > and the numbers of contributors, the larger room will primarily be
> > > for the 802.11 discussions and any "plenary" topics while the smaller
> > > rooms will be for Bluetooth, NFC, and any "breakout" topics.
> > > 
> > > So...thoughts?  Topics to discuss?
> 
> Ping?  We're now just 2 weeks away!
> 
> Is our topic list complete?  It looks a bit light...
> 
> Anyone have any input on scheduling the topics?  Are there any
> overlapping LPC sessions that it would make sense to work around?

I'm attending though I haven't put my name on the wiki yet.

Random thoughts; it doesn't look like any of these are covered in the
regular LinuxConf or LPC sessions.

1) State of the Union (maybe by multiple people in the same session per
their expertise), since perhaps not everyone doing eg 802.11 stuff knows
what's happening in BT or NFC land, or not everyone working on a
specific driver may know what new stuff their driver might need to be
fixed up for.  Maybe 5 minutes or less for things like:

  * what's under the most active development right now?
  * upcoming new driver, hardware, and new capabilities
  * new 802.11 standards
  * and what's coming up in the next year from the standards orgs
  * what people will start working on soon
  * what will 3.13 or 3.14 look like from a wireless perspective?
  * 11s mesh status?
  * anything interesting in wpa_supplicant land?
  * anything new/interesting on the Android front?

2) Bluetooth - update about what's new and what's coming up in Bluez
land, and interaction with kernel 802.11 if any, 

3) NFC - update about what's new and what's coming up in NFC land, where
it's getting used, what the stack looks like

4) What are users having the most problems with and how these problems
be fixed better/more quickly?  Are they driver bugs?  Are they stack
bugs?  Supplicant bugs?  NM/GUI/etc bugs?  Is there anything in our
development processes that's not working as smoothly as it could be?

Dan


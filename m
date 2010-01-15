Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:53461 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758529Ab0AOWvB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jan 2010 17:51:01 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: Ath5k on 2.6.32 suddenly fails
Date: Fri, 15 Jan 2010 23:50:06 +0100
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
	Bob Copeland <me@bobcopeland.com>,
	Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <201001101152.34316.mb@bu3sch.de> <201001152340.40127.mb@bu3sch.de> <43e72e891001151447u39ad494ah6861926db0c50907@mail.gmail.com>
In-Reply-To: <43e72e891001151447u39ad494ah6861926db0c50907@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <201001152350.06930.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 15 January 2010 23:47:00 Luis R. Rodriguez wrote:
> I wonder if a possible failure here might be that the box gets under
> load and some DMA allocation actually gives back less memory than what
> was requested., hrm, but even then we'd still tell hardware it has the
> whole desired length we intended...
> 
> Not sure... I haven't reviewed this code in ages.
> 
> > However, it had different failure symptoms this time.
> > Last time it failed, the AP was completely dead. No beacons, etc..
> > This time it was still beaconing, but auth failed:
> 
> Can you reproduce? Do you know if anything particular happened at this time?

No, there was nothing special happening. I was just sending the previous mail
and a few seconds later I noticed that wpa_supplicant lost connection
and failed to gain a new authentication.

> > Trying to associate with 00:1d:0f:b9:df:2d (SSID='quimby-net' freq=2472 MHz)
> > Authentication with 00:1d:0f:b9:df:2d timed out.
> >
> > A machine reboot was _not_ needed this time to revive the card.
> > Module unload cycle was enough to bring it back to life.
> >
> > I'm really unsure what's going on and if these two failures are related
> > to each other. Probably not...
> 
> Anyway you can burp your box sooner (replace the PCI connector) to
> rule that out?

Yes, I'm going to replace the extender over the weekend.

-- 
Greetings, Michael.

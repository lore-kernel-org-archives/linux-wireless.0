Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:45549 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755334Ab1BRX1Y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Feb 2011 18:27:24 -0500
Subject: Re: [RFC] AI support (13/14 ssb add AI support)
From: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
To: George Kashperko <george@znau.edu.ua>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	=?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	driverdevel <devel@driverdev.osuosl.org>,
	Henry Ptasinski <henryp@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Arend Van Spriel <arend@broadcom.com>
In-Reply-To: <1298070443.25739.23.camel@dev.znau.edu.ua> (sfid-20110219_001605_010946_FFFFFFFFA70C4DCA)
References: <1297958316.5623.27.camel@dev.znau.edu.ua>
	 (sfid-20110217_170718_357395_57E8418D)  <1297980093.13554.5.camel@maggie>
	 <1297981882.23381.38.camel@dev.znau.edu.ua>
	 (sfid-20110217_233956_707110_FFFFFFFFBE33FFA6)  <1298069145.23801.29.camel@maggie>
	 <1298070443.25739.23.camel@dev.znau.edu.ua>
	 (sfid-20110219_001605_010946_FFFFFFFFA70C4DCA)
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 19 Feb 2011 00:27:17 +0100
Message-ID: <1298071637.23801.40.camel@maggie>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2011-02-19 at 01:07 +0200, George Kashperko wrote: 
> Starting from the clean page means another months of no support for
> AI-based hw.

Oh, wait a second right here. That's not how Linux development works.
We want the technically superior solution, not just something that
works to get stuff working no matter what.

If your patchset works, that's pretty cool. So thanks a lot for getting
something to the users that works. Nothing stops distributions from
picking up those patches and distributing it to endusers.
That doesn't mean we have to adopt it to the mainline, though.

> Going cp ssb bcmai; sed s/ssb/bcmai way will make whole
> messup.

Forking and developing a separate solution is not equivalent
to applying cp and sed commands to the codebase.

> Ah, well, there might is another 4th way to go if Broadcom will finally
> support their bus with their brand code but honestly (no offence to
> Broadcom here, just my personal subjective opinion) I dont think I will
> be happy to see this code after all that I've already seen.

As Henry already replied to this thread, I'm pretty sure that Broadcom
is interested in bringing the technically superior solution to the
mainline.

I do agree, however, that their current "SB" and "BCMAI" code
doesn't look superior to your patchset, though. ;)

-- 
Greetings Michael.


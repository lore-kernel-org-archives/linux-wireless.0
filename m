Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from adelphi.physics.adelaide.edu.au ([129.127.102.1]:52736 "EHLO
	adelphi.physics.adelaide.edu.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753909AbYLPACB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Dec 2008 19:02:01 -0500
From: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Message-Id: <200812152342.mBFNgQJj028844@sprite.physics.adelaide.edu.au> (sfid-20081216_010206_944721_0BF937A8)
Subject: Re: Fuijtsu Lifebook RFKILL support
To: tony@linx.net
Date: Tue, 16 Dec 2008 10:12:26 +1030 (CST)
Cc: dcbw@redhat.com (Dan Williams),
	hmh@hmh.eng.br (Henrique de Moraes Holschuh),
	lenb@kernel.org (Len Brown), ivdoorn@gmail.com (Ivo van Doorn),
	linux-acpi@vger.kernel.org, jwoithe@physics.adelaide.edu.au,
	nokos@gmx.net (Peter Gruber), linux-wireless@vger.kernel.org
In-Reply-To: <1229361241.13400.1.camel@localhost> from "Tony Vroon" at Dec 15, 2008 05:14:01 PM
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Tony

> On Mon, 2008-12-15 at 10:19 -0500, Dan Williams wrote:
> > I plan to beat the .... out of the hal killswitch support pretty soon.
> > AFAIK it still doesn't know about softblock, which is part of the whole
> > reason for the rfkill rewrite in 2.6.26 anyway.  It also doesn't yet
> > (AFAIK) support uevents from killswitches either, which sucks.
> 
> Could you let me know when you've committed this code so I have another
> shot at implementing rfkill reporting in fujitsu-laptop?

This is to let you know that I'm still following this discussion but haven't
had anything sensible to add to the basic infrastructure issues being worked
through at present.  It's probably sensible for me to pick up on the next
version of your patch.

Also, over the Christmas period (ie: after this week) my responses are
likely to be slow due to intermittant network access in that time.

I also haven't forgotten about getting you the DSDT from the S7020 - I just
haven't had a chance to get to that yet.  I hope to get to this before the
end of the week.

Regards
  jonathan

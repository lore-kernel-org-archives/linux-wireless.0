Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web51404.mail.re2.yahoo.com ([206.190.38.183]:41767 "HELO
	web51404.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751499AbXI0LoZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2007 07:44:25 -0400
Date: Thu, 27 Sep 2007 04:44:23 -0700 (PDT)
From: Joerg Pommnitz <pommnitz@yahoo.com>
Subject: Re: [patch 6/7] mac80211: allow only one IBSS interface
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-ID: <2113.93857.qm@web51404.mail.re2.yahoo.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Well, the Unix and those the Linux way is "Give 'em enough rope...".
Sure, things might break if you don't know what you do, but the
same is true when you do "rm -rf /" as root. I really don't see the
point of protecting root from itself.
=20
-- =20
Regards
=20
       Joerg
=20


----- Urspr=FCngliche Mail ----
Von: Johannes Berg <johannes@sipsolutions.net>
An: Joerg Pommnitz <pommnitz@yahoo.com>
CC: linux-wireless@vger.kernel.org
Gesendet: Donnerstag, den 27. September 2007, 10:50:38 Uhr
Betreff: Re: [patch 6/7] mac80211: allow only one IBSS interface

[Could you please use reply-to-all and not break threads? thanks]

On Thu, 2007-09-27 at 01:08 -0700, Joerg Pommnitz wrote:

> Well, consider the case that you want to route between
> two *different* IBSS networks with a single NIC. This=20
> could be really useful and those a nice feature to have.

Yes, but consider the case where it all breaks because you associate to
the same IBSS. IMHO correctness is more important than "nice features".
It would be possible to fix the issue, by keeping track of the beaconin=
g
etc. in software and having the two IBSS interfaces see each other via
software since they can't in hardware, but I'm not interested in
expending that effort right now.

johannes






      Machen Sie Yahoo! zu Ihrer Startseite. Los geht's:=20
http://de.yahoo.com/set
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

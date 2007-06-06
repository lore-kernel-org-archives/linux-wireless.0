Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web51404.mail.re2.yahoo.com ([206.190.38.183]:37900 "HELO
	web51404.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1761957AbXFFMOW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2007 08:14:22 -0400
Date: Wed, 6 Jun 2007 05:14:21 -0700 (PDT)
From: Joerg Pommnitz <pommnitz@yahoo.com>
Subject: Re: RFC: Regulatory info in mac80211
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-ID: <727659.61110.qm@web51404.mail.re2.yahoo.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I think this is what initramfs is there for. I'm not sure whether runni=
ng from initramfs
places certain restrictions on programs like the proposed regdomain dae=
mon. If it
does, it would be important to keep these restrictions in mind when des=
igning the
new infrastructure.
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
Gesendet: Mittwoch, den 6. Juni 2007, 13:41:45 Uhr
Betreff: RE: RFC: Regulatory info in mac80211

On Wed, 2007-06-06 at 03:00 -0700, Joerg Pommnitz wrote:

> Regarding a user space daemon: keep in mind special use cases like NF=
Sroot over WLAN.

That isn't going to be possible in any case since we require userspace
to set up wireless links.

johannes






      Heute schon einen Blick in die Zukunft von E-Mails wagen? Versuch=
en Sie=B4s mit dem neuen Yahoo! Mail. www.yahoo.de/mail
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

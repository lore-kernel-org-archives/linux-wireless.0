Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web51403.mail.re2.yahoo.com ([206.190.38.182]:46440 "HELO
	web51403.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754847AbXGBNiB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jul 2007 09:38:01 -0400
Date: Mon, 2 Jul 2007 06:38:00 -0700 (PDT)
From: Joerg Pommnitz <pommnitz@yahoo.com>
Subject: AW: [WIP] mac80211: kill mgmt interface
To: "Cohen, Guy" <guy.cohen@intel.com>, Jiri Benc <jbenc@suse.cz>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-ID: <394827.41199.qm@web51403.mail.re2.yahoo.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

And, just from reading the documentation, it seems to be supported by M=
adWifi for Atheros
based devices:

http://madwifi.org/wiki/ngFeatures

and note the "To create APs which share a single MAC address, use the -=
bssid flag when
creating the VAPs:"  remark.

Even if no current mac80211 driver supports this feature, the API must =
not prevent this in the future.

-- =20
Regards
       Joerg

----- Urspr=FCngliche Mail ----
Von: "Cohen, Guy" <guy.cohen@intel.com>
An: Jiri Benc <jbenc@suse.cz>; Joerg Pommnitz <pommnitz@yahoo.com>
CC: linux-wireless@vger.kernel.org; Johannes Berg <johannes@sipsolution=
s.net>
Gesendet: Sonntag, den 1. Juli 2007, 03:48:06 Uhr
Betreff: RE: [WIP] mac80211: kill mgmt interface



Jiri Benc wrote:
> > Can one run multiple MLME (e.g. hostapd) instances to run multiple
> virtual master mode interfaces
> > for different networks? With different BSSID?
>=20
> I don't think that would be ever possible when using monitor
> interfaces.
>=20
> On the other hand, it doesn't make much sense to support that. The
> interfaces are not completely independent, e.g. you cannot tune to
> different channels on different virtual interfaces. Therefore, at
least
> a minimal knowledge about virtual interfaces would be needed in more
> complicated user space MLMEs.

This is a required feature for Access Points (multiple BSSID).






      __________________________________  BE A BETTER MEDIZINMANN: Jetz=
t Frage stellen und einen von 44 iPods gewinnen! www.yahoo.de/clever
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

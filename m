Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:53573 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757260AbXLRNvo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Dec 2007 08:51:44 -0500
Subject: Re: [PATCH 7/8] mac80211: A-MPDU Rx handling DELBA requests
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <c85cb4470712180546x42217cbdjb7cb6457884b55fe@mail.gmail.com> (sfid-20071218_134627_430781_91173A9A)
References: <11979070692599-git-send-email-ron.rindjunsky@intel.com>
	 <11979070791111-git-send-email-ron.rindjunsky@intel.com>
	 <1197915987.4885.95.camel@johannes.berg>
	 <c85cb4470712180546x42217cbdjb7cb6457884b55fe@mail.gmail.com>
	 (sfid-20071218_134627_430781_91173A9A)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Ohywoac5rm54R1b/5Dyo"
Date: Tue, 18 Dec 2007 14:51:38 +0100
Message-Id: <1197985898.4885.141.camel@johannes.berg> (sfid-20071218_135208_108871_6C75E831)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Ohywoac5rm54R1b/5Dyo
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> yes, i am handling only Rx A-MPDU, so only initiator of the session
> can send us delBA

Ok, thanks for the clarification. Should we log an error if somebody
else sends us one?

johannes

--=-Ohywoac5rm54R1b/5Dyo
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2fQaaVg1VMiehFYAQLZVQ/+MD6MXT2DR6SDM22Gl+6iBL0+hvqXUKOE
8A0YnwGbycixbs2M+5umj5c5DI9xIux+7Y+ctMiMdYqGSQwaTTv2qpU7Sm71fAox
kGcDVh/hXM76v6+reSh8/xu0kFjP4Z2RDsYbTxCApQN8xORTI9GcaPKQd40cAC+7
WFtdxxUA0vgDZxTVIqeQ9TULkDUTlGg0ABVXCYh1tTdW+adzaWIIv4v8502rsgWS
/930j/0a2IEx+Fu8KRmUN/0hTGzvwOS1wrGNT+epVtalSZSviW0LQ1iZgXBj4IFY
AXrzIYcE1chyH37r1b+2jSpjTkq766DoAFO8tOjZnY4Zu8VbDxkiG6j2U1mq7YE6
w7nx048cC0C8z33PFhXZzL8YHvSiXsLsHaLt39QaX6JynkuwknsiYL7PUhbY+93y
H9I4yCYxH+aaFUpGJjfwV28wVpt8YHiLYczvE2Z/1guVBqDNTkTanL8IX1Q12+/o
7p7gigW7sZKX5ZNuN5D7FcRrfeKrQhO7eM57CINbJpwxf0frKTDOAhTw6yHBTI22
EdwIfRXgR5Uqt2TSAkKs5IGLOZEFStd/9cpeJ5z695hnX7iIgKwIEH62XoPCTyWx
ppy1TLevv6BW0QMiCYaxwrhXEIkUTjSfCFagQJbgqBLptpf1TWS/0mMBdFyjrfl1
ckE8MG4jznM=
=0yCj
-----END PGP SIGNATURE-----

--=-Ohywoac5rm54R1b/5Dyo--


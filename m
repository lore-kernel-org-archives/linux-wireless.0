Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54040 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347AbYDSNJg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Apr 2008 09:09:36 -0400
Subject: Re: RE: iwl3945 problem with 2.6.25-rc9
From: Johannes Berg <johannes@sipsolutions.net>
To: Vincent C Jones <v.jones@networkingunlimited.com>
Cc: Tomas Winkler <tomasw@gmail.com>,
	Brian Morrison <bdm@fenrir.org.uk>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1208608786.3980.7.camel@X61.NetworkingUnlimited.com>
References: <D936D925018D154694D8A362EEB08920043535A1@orsmsx416.amr.corp.intel.com>
	 <D936D925018D154694D8A362EEB0892004353826@orsmsx416.amr.corp.intel.com>
	 <D936D925018D154694D8A362EEB08920043539AE@orsmsx416.amr.corp.intel.com>
	 <fu931e$k1b$1@ger.gmane.org>
	 <D936D925018D154694D8A362EEB089200438B6D6@orsmsx416.amr.corp.intel.com>
	 <1208555842.4848.56.camel@johannes.berg>
	 <D936D925018D154694D8A362EEB089200438B728@orsmsx416.amr.corp.intel.com>
	 <20080418232358.000fbdf7@peterson.fenrir.org.uk>
	 <1208558255.4848.60.camel@johannes.berg>
	 <1208558382.4848.63.camel@johannes.berg>
	 <1ba2fa240804181728u7a3440cajbba7dcc696d02909@mail.gmail.com>
	 <1208593973.26186.2.camel@johannes.berg>
	 <1208608786.3980.7.camel@X61.NetworkingUnlimited.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-WaMNlaI0YtefysvUPvrm"
Date: Sat, 19 Apr 2008 15:09:25 +0200
Message-Id: <1208610565.26186.17.camel@johannes.berg> (sfid-20080419_140953_720605_7303CE3A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-WaMNlaI0YtefysvUPvrm
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > Does anybody actually *want* that? I personally dislike the behaviour
> > of scanning for all previously known SSIDs actively when hidden SSIDs
> > are so uncommon, I see it as an information disclosure vulnerability.
>=20
> I can't speak for what others may want, but the Payment Card Industry
> security guidelines include not broadcasting the SSID as one of their
> requirements, if that is what you mean by "hidden SSIDs."=20

So how would you feel if I told you that, after you have once used that
hiddent network, your laptop will be broadcasting the SSID in probe
requests every time it scans, no matter where you are, even if you've
moved across the continent?

johannes

--=-WaMNlaI0YtefysvUPvrm
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASAnvBKVg1VMiehFYAQJWMQ//TMI05+XtGSFH+DxV1FQlGkW9QMm5n48b
S33xiuKKB2awzGeuiiBF4jc1UXLceZFdzNYx2fkRVwQIK/P2qrFISTuVejJAHnR3
3M829XzdK9I6t3aqb6POjBZ4FCm0+jlJZKJCqFX2Em27kD3oMIiIuTUK2eu7+JGu
7MzBPmmPfxNcBN/CJzp0JmU28ParxTkVKf2tsMU2lxeA6Mt1Hu98ONTsv4Q4ZPNX
g9MuJguUuprp47qm0FzCTSicjuq6hEcblTLg3UFYOOA2SB4hMpYWl65ZAJQ4rLyT
GXZwel23mRkql+QlrH+eNnJkW2HtjYEVFgHzXw9wxc0R7RiDu3V3fWJ9KhqNMkqU
bvw7kjoM0GTLE/+s0h9f3GeXVBPZz7Kxjjd7qcCy7RiJsa+Kevl8borfqTaCTojZ
EQcFHrQ7xh5n0vxZVYzjX3LrtK5QeS1ceWQ7ufihPf3sc3kIRV+YCORDVXnHBceH
56hwyitKWyQORlNYy/6V8e73RkE/BBPidh1DDVZrtzwoetHMlzemSp74FyY9jrIC
AbUSMshJ8t6zuOVT4M1AEW93pBzv13WQqlLeAJv5Dto44bqZLyEXOtd4QduRoWGi
KiYDNg3J71npSHUCcGJXWVMTQGzIhy8cyEg7PEBK6IPcjUpSpBcRQilKbkcMTULe
5DlC9pl8w+Q=
=w2Pf
-----END PGP SIGNATURE-----

--=-WaMNlaI0YtefysvUPvrm--


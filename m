Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:34378 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745AbXLEKQj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2007 05:16:39 -0500
Subject: Re: [RFC][PATCH] mac80211: Use PID controller for TX rate control
From: Johannes Berg <johannes@sipsolutions.net>
To: Mattias Nissler <mattias.nissler@gmx.de>
Cc: Tomas Winkler <tomasw@gmail.com>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1196790347.7472.10.camel@localhost> (sfid-20071204_174621_493503_0C4B9F12)
References: <1196622331.7472.4.camel@localhost>
	 <20071203041608.3af3b462@morte> <1196679780.7470.9.camel@localhost>
	 <1ba2fa240712030321g58b8df39y24240c63facba2cd@mail.gmail.com>
	 <1196681514.7470.12.camel@localhost>
	 (sfid-20071203_113229_452420_E8E9CC87)  <1196775624.6060.52.camel@johannes.berg>
	 <1196790347.7472.10.camel@localhost> (sfid-20071204_174621_493503_0C4B9F12)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-QAYdfqg7AG032K3SWcSd"
Date: Wed, 05 Dec 2007 11:16:19 +0100
Message-Id: <1196849779.4121.1.camel@johannes.berg> (sfid-20071205_101643_779738_681E70BB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-QAYdfqg7AG032K3SWcSd
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Ok, sounds good. What is the overall strategy for deciding what goes
> into nl80211, what into sysfs?

None really, I tend to think it should all be in cfg80211 and then maybe
Luis will put it into configfs too.

johannes

--=-QAYdfqg7AG032K3SWcSd
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR1Z6cqVg1VMiehFYAQIo5g//WqYJLeupnRdZPk5tdYsGMx7o5iJrnOk2
dNluTfUDXQVmQCiIeIT6QCBiBeMIiwk3SYvenxasiHeOv1O2OAWJyz9y/rg5mLDW
nViS8rpn568n0wc2De+iAtUW3F6I3Ohu3SbKJ0OT2OswtSMuIOGZUHsA7lAMG8Xk
HI/PXYbxicXbkdxGI1I/CvQfNMuMCnMvPg8qkGWVV3jLA1OupVlhgXxQLq4AJTgL
ffhVjktPk11t0gD1j8e+fEJl4TsvRrxrgOuPx6HC/oxf2ZVmPPNk4LMZsrazKONb
dLvtrIgMdjY4gXkCkF7FxhtG6E/irEJ/7rvRqxdCC5YW/7FFpttBcTlj6sT9U9wS
RbhJ1BHg57RFljAWBo19FFidYJ4t4mVj8GUP6V7X6re4zBHvf+YaAChbHh5w0G4J
qNHAr8CRtJJqK20THfhEtmZZHrw/BrzQe39a7WBVoCeM+oofbMorKUcgLE2XgBuu
Xz+SLsWgb3X6+1gmQfkdYSwLPzZIQQ/2e3WHUeI2A4xmO5raTLv6GIs6eW0Iw/Cz
p1bc7q94xvdg10L1Ju46mtT4pmOx4sPg41TIMVt64z9/SPpkchioooOdz7vcNJC4
IvPoJu6n2MkFXCqRVH4CLQlodfAzL084sBZ3iHlMHMoKbUpqjEzG6GFOYWo8L6X2
Jl72O3FE0nM=
=S8ft
-----END PGP SIGNATURE-----

--=-QAYdfqg7AG032K3SWcSd--


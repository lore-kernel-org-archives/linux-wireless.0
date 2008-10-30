Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57879 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965AbYJ3RVz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 13:21:55 -0400
Subject: Re: Guidelines regarding separate directory
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
In-Reply-To: <4909EA78.3060700@lwfinger.net> (sfid-20081030_181107_189082_5740895D)
References: <4909EA78.3060700@lwfinger.net>
	 (sfid-20081030_181107_189082_5740895D)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-xA/R1Eeg2hyLbPFemooY"
Date: Thu, 30 Oct 2008 18:21:49 +0100
Message-Id: <1225387309.3690.73.camel@johannes.berg> (sfid-20081030_182158_381151_A0F42367)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-xA/R1Eeg2hyLbPFemooY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-10-30 at 10:10 -0700, Larry Finger wrote:
> I am planning on adding code to control the LEDs on the RTL8187 devices b=
ased on
> the latest vendor driver. From the expected size of the code, I think tha=
t
> separate files will be best.
>=20
> What number of files in a driver make it advisable to create a separate
> directory? Between the rtl8180 and rtl8187 drivers, there are now 15 file=
s and I
> will be adding at least 2 more. Is this the time to create a rtl818x dire=
ctory
> under drivers/net/wireless?

I for one think that should have been done already, makes finding
drivers easier imho. But I don't think there are strict guidelines in
any way.

johannes

--=-xA/R1Eeg2hyLbPFemooY
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJCe0pAAoJEKVg1VMiehFYdX0P/2Frorr/4d6yD0CeMWEcmxyk
4aRv6c7Fx5c2HnA2x+h258pn89aunOxIZMkc/5w5O9M5BFud/QRkOyGFNFe2KfRv
sR7PnR8yALgF6oTugCZh52rwN9j8NwjI1pLrmWYLfQL5H/z8b0E9zHafgZ8tTKhx
On9DdC2qbSTQnen8bd+wV64bIZNoRc86kqmXdg3TJ5TutjjvOvdYgyDmfOecWcmG
S/Lo6d7TNtNEh7dRbi4efIbdxUWATqyyUDQIAiVj/HE7ZpHRVq+pv/d4W4JJ9R8G
Y9FWufFxdZAlXjuYquJtwIkqdNmqiGN1mv5/CMx0tAVCowxDBRmxkekUHckFqVhQ
MRCTk+sNKWt1cTq5ePu5rQhK3w3WblpKl/iWyn8abLfM/1AIM5SgBcMiy/3/vZ9X
vTAKqtCh1peoz5tCi+gU27/B+uiRrEtnbJiS7p+3Gmgt62YBuGdWE8cOfHdZx0M8
v+7ljsyS4UaZ3SBP7N+WqXOkdWvHqHtNRT7wOCN+MOx16D72qey11MdNKRgWYrhK
g7H6f0U5tq4CU+wp8NpxoQuQRerTfOvmAIqExOhnEtHdypt0HXFg10jxjuuzP+EX
TzeDG3mtdS0ufeotlZ1EQZNq6FjiNjpYZMsK7iHpQZM1U8CVqvhuSI+yS05s8+Rx
Ee8cAGpmW6bmI3BACoZB
=30wC
-----END PGP SIGNATURE-----

--=-xA/R1Eeg2hyLbPFemooY--


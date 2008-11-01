Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38129 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651AbYKAOyV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Nov 2008 10:54:21 -0400
Subject: Re: [PATCH] mac80211: Allow AP mode to be enabled
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: Jouni Malinen <j@w1.fi>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <87vdv7wld3.fsf@litku.valot.fi>
References: <20081030175030.GD3923@jm.kir.nu> <878ws3ptrh.fsf@nokia.com>
	 <20081101114754.GY3923@jm.kir.nu> <871vxvmsnd.fsf@nokia.com>
	 <1225549954.3619.4.camel@johannes.berg>  <87vdv7wld3.fsf@litku.valot.fi>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-z0865bxeJTh4oDR7sKwT"
Date: Sat, 01 Nov 2008 15:54:15 +0100
Message-Id: <1225551255.3619.9.camel@johannes.berg> (sfid-20081101_155424_160677_05108ACA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-z0865bxeJTh4oDR7sKwT
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-11-01 at 16:51 +0200, Kalle Valo wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
>=20
> >> Thanks a lot, I updated to hostap commit 4aac554c and it works now
> >> with b43. I was able to associate with N810 and ping worked. Even PSM
> >> seems to work, but I haven't made any power consumption measurements
> >> yet.
> >
> > I'd be interested in power consumption measurements, but it should work
> > fine.
>=20
> I did some quick measurements with N810 and, like you mentioned,
> hostapd/mac80211/b43 combination seems to work just fine. Tried with
> DTIM 1 and 10 with beacon period of 100 ms and power consumption of
> N810 is just like what I was expecting.
>=20
> I have seen a lot of APs with buggy PSM implementation and this setup
> isn't one of them :)

:)

> > There might be a slight bug in b43 wrt. the beacon timestamp offset
> > though.
>=20
> If there's a bug in b43 I cannot see it from my measurements. Usually
> I have seen any problems with the TBTT right away.

Great, thanks for doing the measurements.

johannes

--=-z0865bxeJTh4oDR7sKwT
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJDG2TAAoJEKVg1VMiehFYOh4P/A+YJhoC0VpJn9mE5Jah+f6R
N+sPicLpMFfQOz6YgM7T5UuCrrspK43TZKplExI8LlKKjcf4lXOCO1uHeZYkmczJ
g5QuA0LvHCcPycU5eMrhaSuRhQSE2yHsZXzWklKhQeeaFKVXA4Igfefk0yCfV+Fb
jxt0ltm3gMiw/w5rtg//2EMu2mJGfbJ9H8PNZgTjoXOLcu6tyl7+M3pZs0l6Fhef
/DMppXlgsssyrimk+ZyYUziqz3UJKb5sdJsOxJxx2JKWLfAETk4+EHhWEuX6eTif
ERfwLMWzMsnPE+BsoeFdzYVBEt84V3T0dwOjxu9Jak3pLNptKarHuEJAjuulG02P
OjoWwV4ZqRf4xNQMg/p0sw6UgZ5MLTQCGp1MrOCogBXrjx3fztYkhofEMTDY0Jtx
6WmSUakRBtUU/x4t89HDSS4WBNXnww5mgW9Qos/MQrKItC79rpQAcnwZLSwFAzgh
SlgMU2y/gDtIaNDp27RezdQilHUaOUbfzTuDo4odBUPItoaf0HBDJ5Ct0n36k6II
sXyR4iSrYkrfLDR0zruPluP+lxEkDt9UC+Mhwl7r7KH1hZlS8re3gQC6MA36/eFz
BxtBcqKnu1dziip84FJ1gkyedNvq0GEHPeMwrP25su8sjGb49AvLvGP3//B4tXHt
qunpB9TgTGEgU1PRdf5z
=9nKh
-----END PGP SIGNATURE-----

--=-z0865bxeJTh4oDR7sKwT--


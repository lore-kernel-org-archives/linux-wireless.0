Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44511 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063AbZDBP4C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Apr 2009 11:56:02 -0400
Subject: Re: How does rfkill work?
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <49D4D833.9070107@lwfinger.net>
References: <49D44635.80306@lwfinger.net>
	 <1238666206.4141.12.camel@johannes.local>  <49D4CF50.2060100@lwfinger.net>
	 <1238684527.4141.63.camel@johannes.local>  <49D4D833.9070107@lwfinger.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ndec8FARp+B4RdRuj/MP"
Date: Thu, 02 Apr 2009 17:55:22 +0200
Message-Id: <1238687722.24708.4.camel@johannes.local> (sfid-20090402_175606_867635_8C8B5325)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ndec8FARp+B4RdRuj/MP
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-04-02 at 10:22 -0500, Larry Finger wrote:

> Without your "rfkill rewrite" patch, but with "rfkill-remove-unused-code"=
,
> "rfkill-remove-deprecated", and "rfkill-remove-user-claim" patches, the f=
ile
> /sys/class/..../trigger contains "none ide-disk BAT0-charging-or-full
> BAT0-charging BAT0-full ADP1-online phy0rx phy0tx phy0assoc phy0radio [rf=
kill0]"
>=20
> Now I know what should be inside the [].

Indeed. But it confuses me that this isn't in there to start with... I
haven't found it yet.

johannes

--=-ndec8FARp+B4RdRuj/MP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ1N/oAAoJEKVg1VMiehFYy9IP/jhjAaE2YLNwfXkzHh/PyJxZ
WhGITSPPlIta3CGN5mSuZf3zt/AoULbvCeTvxcTyW9+mkK//OqZ1QGz/u5rCNTk8
Rats/4uTdAra7xxEFT+waBa587J+LQvp8Q6Z9qt8H8UzKVlva1obyXioZ8W0vGJa
B8afqdMXAyXSIr87siLHO0jBcHQBRzWVwGlPav/B/KbOMhQGIltu65P2w6UY4YXS
eKSxH1czONpYQgzybBzWHrwbBHUZ9Kd2asOczfUyonOV24EgeI1xI+kyVAqSKQbn
2pfBt6a1CgQbV3/HMxRRgDFs33DbQhHfXOZKoJGwRdWAmKeycAixJbkfLZ+GZbZm
NwmXOmDQIpL3pmYhw1fNBBpqOUeRMjSpRjllXbnNWkbA9hIxe1iJmYGisT1+70hO
i7toYeYaKZKlq/RDK/n36ohRR4Pamaan66bz3g+kVsZZPGTAVEMVVJ/vbqWCjFFF
QVDSlVXQXU8iz+K2J5V7xH7gG33vqeR24aOiALvE6n9cyZQS7+OO62iEpTTyeJc1
VFHgHmHUnSyn9ynBM1fIjLO6h7A0WK/qq17LEiZhVK5okabjTwm3RtKdLR8hXouo
zkwMif37jaAXThm9IBEsRz16Zs7AsdJMQqqENcVKhVSiUMdh6aAzS2hpuwJ+2VR7
BnA+zCioSCaypoBOaBpN
=xUJE
-----END PGP SIGNATURE-----

--=-ndec8FARp+B4RdRuj/MP--


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38512 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbYE3Oho (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 May 2008 10:37:44 -0400
Subject: Re: suspend vs. b43
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200805301606.25556.mb@bu3sch.de>
References: <1212150713.4117.2.camel@johannes.berg>
	 <200805301606.25556.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-rdtXCWFZP6hF8B3HYi/i"
Date: Fri, 30 May 2008 16:37:18 +0200
Message-Id: <1212158238.4117.4.camel@johannes.berg> (sfid-20080530_163747_793284_8ACE6B2A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-rdtXCWFZP6hF8B3HYi/i
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-05-30 at 16:06 +0200, Michael Buesch wrote:
> On Friday 30 May 2008 14:31:53 Johannes Berg wrote:
> > Since a while ago I've had trouble resuming when b43 was connected to a=
n
> > AP while suspended.
> >=20
> > I did a test today where this was the only difference, but I failed to
> > see whether ssb or b43 were causing the problem.
> >=20
> > Does anyone have a machine with b43 in it that can suspend and supports
> > the RTC-trace feature so we can narrow it down? Even reproducing might
> > help to make sure it's not just something weird with my powerbook.
>=20
> Resume is pretty broken since some time for me.
> It sometimes works fine and sometimes just hangs with a black screen.
> I have no idea what's going on.

Odd. Resume itself works just fine here, except when b43 is up. But then
again, you might not notice that this is the problem because by default,
nothing gets printed on the resume console and then it will indeed hang
with a black screen.

johannes

--=-rdtXCWFZP6hF8B3HYi/i
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASEARHaVg1VMiehFYAQKrbQ//afG7Q257Jyd1CcCRq95MPDOuls8IXmqh
ogCGEc1oB4XfEXlf2pcxoapQpA3ILS0yvV88jk0QfMLFjPThIkcyRAIJ0nmwB+WI
ZyrQFI4cQwfIWKNwqkz7wYxY2n3AUPr1NOLx28To5PIfvKd34VLwUN2lOlsbiRYa
S8x9KNUTCYVY/FxHv6DLajFrlvTSzUZvhuKPnMOxCV+fjCzHmzu4LxbYcWzJYPOW
haYWXYdeNgDJFGyPSNJuGK/W+ab25JltiL/ONwp4zXrpLQxnnNkOshn/GPopyTfO
Omd/tnCjGICzIEoMGwpg2whUmhcR0hj5Ls7c0VJfqAD7NPP/hyujzXKOqkINDqtx
knwflx5/PQ8OukGu56vsM1sAKB1IQEuW7hBxKhZDxK/MLiEVP4bIa8BSLeeWjtbM
CANnAI5SkIqHEC6pDkxL7M1WF3/+hGta6bDDp5z6XkEzdA6WLO6NKtlJhZ64rnqK
94Hid5RxWa+R4FHLWrTKi560mr58feoMt9ofruvdmFgrCQPC/i4ATnoleuiRmH/F
yiAxHEvrFMK06MqPCTwNzwaY6WSSre3CgmEzKOjJDEdWNeOhUKMdUNjaWF8Dnp9s
1Cr18DzDlf8fylGnJ8Xzgpx+FG/4H/OUiv3oMag4hI3TOIk6sDtUbpfN96/zmrgS
YzuZrAh7t+M=
=3M05
-----END PGP SIGNATURE-----

--=-rdtXCWFZP6hF8B3HYi/i--


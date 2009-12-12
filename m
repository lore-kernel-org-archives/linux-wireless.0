Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54547 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761468AbZLLKZJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Dec 2009 05:25:09 -0500
Subject: Re: mac80211 noob question
From: Johannes Berg <johannes@sipsolutions.net>
To: VN <vnik5287@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <157c4da70912120218lc53633bk62fc9ee99377a231@mail.gmail.com>
References: <157c4da70912120218lc53633bk62fc9ee99377a231@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-bLsUJPawexXE3z72IP1J"
Date: Sat, 12 Dec 2009 11:25:13 +0100
Message-ID: <1260613513.2442.319.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-bLsUJPawexXE3z72IP1J
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-12-12 at 21:18 +1100, VN wrote:
> Hi list,
> I've recently started hacking mac80211/ath5k in order to implement my
> idea of cooperative relaying. I had a good look at the mac80211 code
> and couldn't find anything that deals with ACKing... or is it done in
> firmware and some flag is set to indicate that the frame has been
> acknowledged? What I'm trying to achieve right now is to receive a
> data frame while in monitor mode (e.g. ieee80211_rx_start_monitor())
> and then check if it has been acknowledged by the destination node.
> would be very grateful for any tips!

I think you're confused? If you receive a frame, your own hardware will
have sent the ACK. If you TX a frame, you will see it on the monitor
iface with the radiotap ack flag set or clear, see hostapd for example
code.

johannes

--=-bLsUJPawexXE3z72IP1J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLI2+GAAoJEODzc/N7+Qma5VEQAIYcKhJaYJz3URiTuvr5NSMc
kUvCJXNH/xZ5tihgf2S/odu1p84WT4HIxODGHO65YUYgb6q0wqh8CigjUDWV18+p
rq12qs6h8TuNrFW7YRtjs84TYzXkMBMFhpAx+VtmzAkx3YDklptVgwNrwJuOuMJr
rWFWHaRufGK6oMpM8QMaeoG3aoDPK3pMlDFrzJ1KdjN7PzHowxZLSIfNNl9rlv9K
KOe+dPCk25BheHrYOC98+mI2BBcfV+wOas4u3X8IudeguXqxlEZZGfjcf5hnwB1R
AL47L50tSdure+7TvSFbYr9YgfVT6odec/EAj/dkXpoqTA7H3/Jw9ce3tiMqTA3C
i0TPJirvkW9Npnhj5dt5jvS1QaAY+NFa4NHp+m5fUD3DkMz200mcDiqXcNV06lbd
ASAph/3IYWOMqySs1jCWHBJQf0lWgKCofk+x0/DHJ9m9ErcmxtnJVw2YXqlouo17
k1epdTIpi/rDhzdK4WBWky2+G7W0ZC5zr/tq/9IQRIm0ZLHAf2j71+4SiteVuhaj
RVgDM1OF/dft9JxPsGlNnBDVKjWHcLvnEx7nSVjrv8UYFOHmpO9mOkDfH/pN3PV4
wbL1ZoFWUS3Tqt/iz9mlLRnPRXmANeJNgp2d7XCLBNHNghM+dxIW1+lfALLoO5Bo
lZ1RH/n7tfm/z2wA/pn5
=Fsq7
-----END PGP SIGNATURE-----

--=-bLsUJPawexXE3z72IP1J--


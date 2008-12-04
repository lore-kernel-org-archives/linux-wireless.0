Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58081 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194AbYLDW3X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Dec 2008 17:29:23 -0500
Subject: Re: [RFC] mac80211: remove WARN_ON() from ieee80211_hw_config
From: Johannes Berg <johannes@sipsolutions.net>
To: reinette chatre <reinette.chatre@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1228429462.28477.77.camel@rc-desk>
References: <> <1228425905-15666-1-git-send-email-reinette.chatre@intel.com>
	 <1228427824.5692.52.camel@johannes.berg>
	 <1228429462.28477.77.camel@rc-desk>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-MnprGQhVaWvbMo1ndUAd"
Date: Thu, 04 Dec 2008 23:29:20 +0100
Message-Id: <1228429761.5692.54.camel@johannes.berg> (sfid-20081204_232926_992753_CF9F2D90)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-MnprGQhVaWvbMo1ndUAd
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-12-04 at 14:24 -0800, reinette chatre wrote:

> > I suppose the probability of the beacon interval changing is rather low=
,
> > but should we propagate the error in that case rather than just using
> > -EINVAL?
>=20
> I do not understand. By returning -EINVAL the error is propagated up to
> nl80211 from where the call came.

Ah, but the error code is lost, the driver might have returned -EBUSY or
something. I'm not sure we want to pass that up, it might be better not
to, not sure.

johannes

--=-MnprGQhVaWvbMo1ndUAd
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJOFm8AAoJEKVg1VMiehFYqS8P/0Jzy0nSFqItkiwnP9cjx0bh
JD4Pt9t3+3lDDYVU5vi0kSb4sVbazBO8DKMuaP+1M/2zI8AjY0MUhcacQaG062WV
MEIF06xM5S0tciqtUH3JjuQaSfbR/dRclWFE01RtiZdSp8cOs3jOSXIJcPhBsCy0
KCd4ajMpmkG3/SQFAXrb1NLGAjTXGRdTi2YIUlomQP8cslq4wzbDK+jXjl+vX8Vj
FAjjps5zccMepV1oS+DG1aKWzE/8KXPPjEHCelRtWYHxSomc4/+CxRqzqTI1fLrb
1nYeV9nSiCHB3RXW602hdSGX1fG/6ClnvU8Jk/3qF369lupJTOApOWJyu+iUiYpj
+aMRHdnUpbdnuVv6N1OtEwTlSh7rLTBsjhoJllF1Lj14JfDjQrircWl1aTB7BOSw
L9Lvfd7vId+1VoQTligIhluMkpldkU2jTi8z1CYrD1VNoWlmQI+TtTrnxSL7Pez2
/q7CJ98FkTlPEANCRBU6Icxb5DuObIvI+o3YQwNM5u4eQh+bogkjZRrllC6FRDKb
CFh/M1TRJdsT+EoZ4CIfX18go5Uxh1XYGuvVWe0+qajkkNd2ADtFV6TTC6peiN/M
eZ946hmn0IJ4JFq76a9tvZ6fNZOwnQUGnR51DhrrRvGye1cJQBuNF809mw2RbCLa
vJF/gYbJZYBEjxvlOFWn
=9Fsh
-----END PGP SIGNATURE-----

--=-MnprGQhVaWvbMo1ndUAd--


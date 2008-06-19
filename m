Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36010 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755433AbYFSGsN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jun 2008 02:48:13 -0400
Subject: Re: [PATCH] iwl3965: remove useless network and duplicate checking
From: Johannes Berg <johannes@sipsolutions.net>
To: drago01 <drago01@gmail.com>
Cc: Tomas Winkler <tomasw@gmail.com>,
	Linux Wireless <linux-wireless@vger.kernel.org>,
	Zhu Yi <yi.zhu@intel.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <f6ca9fed0806182313p7f8d5d65u2ef6b5f93e21c394@mail.gmail.com> (sfid-20080619_081319_932768_564E20AD)
References: <f6ca9fed0806151105l3ddd72b9r5a4ad5f112cc8599@mail.gmail.com>
	 <1ba2fa240806160109q751e6990vf9c12e65800fb16a@mail.gmail.com>
	 <f6ca9fed0806182313p7f8d5d65u2ef6b5f93e21c394@mail.gmail.com>
	 (sfid-20080619_081319_932768_564E20AD)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-NRfRXWQgT3gjEZ8PxFdb"
Date: Thu, 19 Jun 2008 08:47:34 +0200
Message-Id: <1213858054.1312.41.camel@johannes.berg> (sfid-20080619_084817_852346_61983149)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-NRfRXWQgT3gjEZ8PxFdb
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-06-19 at 08:13 +0200, drago01 wrote:
> On Mon, Jun 16, 2008 at 10:09 AM, Tomas Winkler <tomasw@gmail.com> wrote:
> > On Sun, Jun 15, 2008 at 9:05 PM, drago01 <drago01@gmail.com> wrote:
> >> Johannes has posted a similar patch fro iwl4965, I have ported (the
> >> relevant parts) to iwl3945.
> >> I tested it and its working fine so far.
> >> -------------
> >> mac802 can handle duplicate packages on its own, so let it do it.
> >> Based on patch from Johannes Berg for iwl4965.
> >
> > I'm not 100% sure but currently there is missing checking for fragment
> > duplication in mac80211.
> > Can someone confirm?
>=20
> Johannes?

I don't think it is missing since the code checks the full seq_ctrl
field.

johannes

--=-NRfRXWQgT3gjEZ8PxFdb
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIWgEBAAoJEKVg1VMiehFYnrQP/RPaqrt8BBOZ95Z5pBvgOA6Q
to8s26/M225xW+x2PTBJaRS6VwCnEZfpPmCPxaMLoDGpJi8zk5TPnJQ2iaY7t1cY
mXVQm+nqaCO0M2h33a+QsKdZMXui0roLaXSQKMyUVjIHo/KJ4g/mxv9vXaoxY0Bv
zB3TCaJ100ZhOqKHnO/d4wwkGCa9iRIvGgH8SKeMg3H7mX+3Z5gK2jvOyuTzBpbN
A/QIwe88yTMcMORooxd19tRyp/R0Fq9ngsiIe+/5r4k6F1V4nujtJn1LNbWyoKRg
1XX4uXhHYS3hfUmvDPeyG7l1vnGa1GlCb7Zor97nZ43k2bX8ZV20cHg54VJc+OGg
nKJF92fo6YhLr06qilC0Tv/NET9uXXoehUAUww5uW+wRVIKVGVHT9/yfrppO50ry
N8vl8kUKJrUhAFx9rb2cxSWxKEfNxPOLYk0ZIaJRfrbzbeE+Pd2mpb8E3pIUiEWF
8aIFBLcio4QXd1t5ocgR3K0AgnSccCu2mlbujoyAXJm7lTbtFyonJhuKpE+JyJ04
ucr8gzxK1ccUSz1HuJuxlKilX7v9gF2U99fOzbq5/Q8vxZIkpUf3J31TYL/f8hyv
nVL0g+eJxYbIM9JNKkYToNy04QMf3wpscOVnalzVa3rNyaVxR5VbSsxXrCS0u3ZZ
CV6AR1iyE51K1Sf95xxV
=5NB9
-----END PGP SIGNATURE-----

--=-NRfRXWQgT3gjEZ8PxFdb--


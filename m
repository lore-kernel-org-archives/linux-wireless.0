Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40002 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540Ab0BEPyV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Feb 2010 10:54:21 -0500
Subject: Re: [PATCH] mac80211: fix bss_conf.dtim_period
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <43e72e891002050752w3dcb736ek4c5fd773ef402755@mail.gmail.com>
References: <1265366706.3613.3.camel@johannes.local>
	 <43e72e891002050752w3dcb736ek4c5fd773ef402755@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-KQE0DJzP0pRjbFx66zB8"
Date: Fri, 05 Feb 2010 16:54:15 +0100
Message-ID: <1265385255.3613.17.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-KQE0DJzP0pRjbFx66zB8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2010-02-05 at 07:52 -0800, Luis R. Rodriguez wrote:
> On Fri, Feb 5, 2010 at 2:45 AM, Johannes Berg <johannes@sipsolutions.net>=
 wrote:
> > In AP mode, the only mode where the parameter
> > is supposed to be valid, we never assign it!
> > Fix that to allow drivers to avoid parsing
> > the TIM IE for the value.
> >
> > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
>=20
> Stable fix too?

Seems no driver actually relies on it, so I guess not.

johannes

--=-KQE0DJzP0pRjbFx66zB8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLbD8kAAoJEODzc/N7+Qma2DwQAMngmuy9gW0kbgmXs6EvJ59l
5CJt/JjF37KcIrXdzxyGaIonyqELxujHa9p1rzTsAK7DtN9qI2o76Wdz695P8P1s
PBMCKek6fV068iA8Nbp9jG6rZHWzrXxteUiAZ/0TfxLrQlHBXUg+jHfBfc0Su6sx
ADh033TZiXoH9+/uv16U5J1g4M2yajttXONuTa/2zrKrLT8RZuM2xMkuIEQPmcm/
a9ZFaD5f6S8CoWE2c0lEN6+r0B73LLArJ19Us3uXB9hw+a23W+NfO1iSGPzvQ6Oo
v9IgnI4lg4pn1VxGWiGc8Le2AEgJeji0gD9HMssMEFFrCRstkxYJDi/4JEJG3IqD
7IB4mRWUrrpJi+46OyiqJy3H4Dh8v3MGNXbAkxQpQjbN1FpGdPq+EZUgB4wY2kJH
znxXZk739WArCpdFo2sL8rCPkY6vK7GVfSyzXa/OuJsNbj2flqXJdoQJ6tjAOFlQ
qV14uONdCsK2XmL6lBGo+RX9d+xFfk7JboU+a/n1sx9d4RAojX/eRNp8zuKQbuim
fGsqActiB13H6eBo4S3pRXsC8p99UNvV8llMbUprQGaoIEQBUSYDPQXrxo8NBiSG
Is7BO2n6jDuXjcrLhpvVHKmGs9FxqwkikCenWiWq/dL4gycJKvzr1h8hsb2SBtCx
ZvmTri7plAWIWIZSdubD
=SG51
-----END PGP SIGNATURE-----

--=-KQE0DJzP0pRjbFx66zB8--


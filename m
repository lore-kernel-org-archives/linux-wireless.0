Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59561 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753623AbZB0VCb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Feb 2009 16:02:31 -0500
Subject: Re: [PATCH v2] mac80211: Call commit() on channel setting
From: Johannes Berg <johannes@sipsolutions.net>
To: Alina Friedrichsen <x-alina@gmx.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <20090226234307.51520@gmx.net> (sfid-20090227_004341_064030_7F5271DC)
References: <20090226234307.51520@gmx.net>
	 (sfid-20090227_004341_064030_7F5271DC)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Kuta6lGw2UGzeKO67g+1"
Date: Fri, 27 Feb 2009 08:20:53 -0800
Message-Id: <1235751653.7426.6.camel@johannes.local> (sfid-20090227_220234_402795_322B1174)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Kuta6lGw2UGzeKO67g+1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-02-27 at 00:43 +0100, Alina Friedrichsen wrote:
> This calls commit() on all logical interfaces of a physical interface, if=
 the channel of it is changed. Before it works as it should, I must fix the=
 joining process of STA and IBSS a little, which I will make tomorrow.

You really should remember to linewrap your descriptions.

> +	list_for_each_entry(sdata, &local->interfaces, list) {
> +		ieee80211_commit(sdata);
> +	}

That doesn't look like it can work? sta_commit/ibss_commit? Separate by
interface type?

johannes

--=-Kuta6lGw2UGzeKO67g+1
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJqBLjAAoJEKVg1VMiehFYxNcP/R11b0Oot5eLbOZddIJCtrbP
RFz6qrJ4r6U/C4JSgK3b48hwcTDvXvtY0GoFXDOsEXZFOGElntY8lkG9LtjC1dej
gp3VQD3TbRX2t14kfvuv1XNA6YQ1EbgUe4GfgoDSnYqSzTyopI/xARep36tcjNIM
CQhhUOmO2VQ++aDcz7AOGozr0bWmkenLFUCuopJFL5gQ8WIig2lzwdQBt0uNOtT3
ByeJ4N3i+cZkT9ORruLlZAZxfnIPoGYTZYISEEvz2Snou5A5OUmdmUoQN3m6AN2/
970knvME5vW2o/xaQYuGMkUYopCuV4J5xL5msyUP9QSL4CPc4u4VlGSUT23Pwz2K
cJPvi0MlGqYyMnGf1z0wCBsDdbdvYVdh6sz79EVtyjav/1zO3sLJ5dIf7XbLH+Yg
ZWZBC0Bq5z6hVvEdsiL7dyOfkxx0ljv3TJBBpC4G5t/A4py79LLj9odwAUy4J/ux
4BDrW+K2Y4a8+BSYrFEU5JXmZbYkcilF/9vDNGs7+zbm9LI7FPAnX4SrrEvEdkXL
qsGk78eUpIZWunuyJ6h7EBnBcfkGa34v+DuHoGLr6EVA7CCXJRIwAMIoR80L26Ex
gMWdJcCXw7sIep4+HfyLYG2o0rNe6bWPV+D/URv0NBymdI3IcNKqHunwtn8rKUL+
ptm5b0gco7S1keRmqz6W
=Co7Y
-----END PGP SIGNATURE-----

--=-Kuta6lGw2UGzeKO67g+1--


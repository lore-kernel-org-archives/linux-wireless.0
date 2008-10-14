Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60520 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbYJNJci (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2008 05:32:38 -0400
Subject: Re: New Regulatory Domain Api.
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1223976427.2570.180.camel@debian.sh.intel.com> (sfid-20081014_112820_318183_742CE064)
References: <B27EBC40D200ED48A3F4CC2EBEABAE0B16C892F2@orsmsx501.amr.corp.intel.com>
	 <20081009154547.GB13349@tesla>
	 <1223608949.2510.1061.camel@debian.sh.intel.com>
	 <43e72e890810100949i78c1d813x1b66c6bc0239ef28@mail.gmail.com>
	 <1223967581.2570.144.camel@debian.sh.intel.com>
	 <43e72e890810140004k6bfa72edsf39acbafcf317fa6@mail.gmail.com>
	 <1223969808.2570.153.camel@debian.sh.intel.com>
	 <43e72e890810140204ne135e72kefe379dd3d26f7bc@mail.gmail.com>
	 <43e72e890810140213w291d729cl6c1bd1149109320d@mail.gmail.com>
	 <1223976211.2570.177.camel@debian.sh.intel.com>
	 <1223976427.2570.180.camel@debian.sh.intel.com>
	 (sfid-20081014_112820_318183_742CE064)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-TFGcvjd+uRE7HZ+imMDR"
Date: Tue, 14 Oct 2008 11:32:01 +0200
Message-Id: <1223976721.10113.24.camel@johannes.berg> (sfid-20081014_113241_251362_49AF2621)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-TFGcvjd+uRE7HZ+imMDR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-10-14 at 17:27 +0800, Zhu Yi wrote:
> On Tue, 2008-10-14 at 17:23 +0800, Zhu Yi wrote:
> > Do you any better way to solve it?
>=20
> For example, consider the driver provided reg_rules are driver private
> (per driver). Don't make them global one.

No, that was intentional so if you have say an Intel card builtin and
plug in a ralink usb device w/o regulatory information, that device's
information is used.

And making it global but then applying it only to devices that don't
have their own information is actually harmful because it suddenly means
that not all devices are restricted by the same rules which would make
it effectively impossible for a user to verify she's operating within
the law.

Why is this an issue for you to start with? Can you not use crda on the
system?

johannes

--=-TFGcvjd+uRE7HZ+imMDR
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI9GcNAAoJEKVg1VMiehFYO08P/2X40mQgizpUtGpjlZiARTLQ
bjuyh/IeCj5Rjn2oKyKa/UITqHuV4Ic9c81q1NUO2uiactJSEicGs8JmevlkD+ad
isZ6A7YTJeNFzLUtMqOHS/D1LobzMYelCkcMD6w+Z4/ZJS3JRG7wAjKRmkhknL/i
4wxZSWmUfdeidzs3ETi0X0E9EMnFCOUn30hkn4PFJ48MqXaetFS7lWP6WihY702b
07wdBi2RDdhwHxwgkzaWU3zPVi0/mpwvh/enD10nmUchiIU9ZTGdApU+INniMA8j
/C/UOHsKWLT4aW43MeEEnXa4J7MWkQAYvLwUjPEITPB5Ywq195/ZeHYojMDbsYY5
1UOTucJWDFiAzlL5W3+h+px9ePxoTS4XQxefbsg6tg0xnRPchEKe68zlrEJR0fJ8
JBt0ULeG5P0j6Dht1vFATaqpcammOTHAFNeUjktG8BkuaiSdhmN+iTSC+ZeOIZya
h8sdKaWeEcPNxmRJ7vtpLRKPrqDIRxVX4IAK3FXXJ6QxajBuE/p+G1Zh369Md35f
Ipzj2YO6htG+aSzzPAd+vLNwt9HWHjwT29aYmb96uuz9Co0+UN1j1TEJZUtrS/G7
twburuSOhiguWuF8ifrnvnnIwabPY9PLw3N4FGX71Vj9U1UnyBq1JXhTnV5Nf83P
N5RbR7MbYAEpaZSjn7su
=RL62
-----END PGP SIGNATURE-----

--=-TFGcvjd+uRE7HZ+imMDR--


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44408 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbZFAO3O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2009 10:29:14 -0400
Subject: Re: [PATCH] rfkill: create useful userspace interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
	Marcel Holtmann <marcel@holtmann.org>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20090601133351.GI11011@khazad-dum.debian.net>
References: <1243524688.10632.0.camel@johannes.local>
	 <9b2b86520905310213n7be56260lc0c2cf3c109fe065@mail.gmail.com>
	 <1243763887.19302.29.camel@johannes.local>
	 <1243796509.6570.35.camel@localhost.localdomain>
	 <1243841639.5299.8.camel@johannes.local> <4A238EA2.4040106@tuffmail.co.uk>
	 <20090601122839.GB11011@khazad-dum.debian.net>
	 <1243859931.5299.17.camel@johannes.local>
	 <20090601124553.GE11011@khazad-dum.debian.net>
	 <1243860606.5299.21.camel@johannes.local>
	 <20090601133351.GI11011@khazad-dum.debian.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-h/NS3tgleZ9xZ99LeNO/"
Date: Mon, 01 Jun 2009 16:29:05 +0200
Message-Id: <1243866545.5299.25.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-h/NS3tgleZ9xZ99LeNO/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-06-01 at 10:33 -0300, Henrique de Moraes Holschuh wrote:

> I don't know if I have any gripes with your latest patch ;)  Can't test i=
t
> right now.  I was reacting to the comments in the thread.

Well could you read it and see if the API does what you require? A
discussion about that would be so much more useful than handwaving about
LED blinking and security issues...

> On a related note, Johannes, would you be opposed to exporting something =
I
> could call from thinkpad-acpi to request a radio state change on a rfkill
> struct?   This would allow me to remove some of the mess in thinkpad-acpi=
.

I don't think I understand what you want? What do you mean by "request a
radio state change"?

johannes

--=-h/NS3tgleZ9xZ99LeNO/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKI+WpAAoJEODzc/N7+QmaySsQANOHt/THOlboWhffHyynucmm
tZsAOq1YhxliutH5guNegN/tWodqPEp191gwy4MH3qmWMLy8k8EmjMrrxFux4e1i
9x3nPk105X4thL7UjCgIKKVO+iDotW3YiEfz9x9bzOOegnejundGdkezHe88Jp5x
pMwQAHStOhUgZpqJmISYN/W3h25fpTPY1er0W9cmFCNvAntVh+vvkJBw/LbzI4Xt
QXNXltquI2fnUBPTeb8OANKQbFou5V4CMpzwrErzlyXeBXiM9m892HPs9apWS6hy
/S4iu51HykM1JYFWJ7oEGt0Vd+FDJz48mgpej9z0PHnyD0V4qlXCCD/ccLbgKpZQ
E5NnZHuO5dUV9Hj8iUIg7aO3lgRme/R3W9/gyO1FEOj/C3unkB46WsxY+f0IBggb
YJkNZa7OWpqJJZqDniFqOuTq1FMS+xdbyDD7z0Mc1Njl73/27QkMuRpOIakeU0Wy
Wo2ilBoI0mSi1QFJjieIabui4z3kumEpcjubolypAAp2lX1JHqP0GDt8l5EJqPFe
RfnbEuAtzGuJFWWLfVyV+iccTpBT0S3NOxjNEpfg3P2mpCa9NR/qOjxb21F/FKTo
RoEFzePXJN4/+Oc1y4u5K5qvs8GcCIYg2YhDH84utCQx/R8+KbXprrbZsGgvJkNg
KPhirplFB/09WNLBaIV+
=X8xa
-----END PGP SIGNATURE-----

--=-h/NS3tgleZ9xZ99LeNO/--


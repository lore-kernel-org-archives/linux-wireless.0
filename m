Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37073 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588AbYLHTxI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Dec 2008 14:53:08 -0500
Subject: Re: mac80211 user space
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: igor_trindade@yahoo.com.br, Jouni Malinen <j@w1.fi>,
	Andrey Yurovsky <andrey@cozybit.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <445f43ac0812081017q2ac6ae1h84a86099518773cc@mail.gmail.com> (sfid-20081208_191702_981904_BC48F1B6)
References: <456087.50493.qm@web59308.mail.re1.yahoo.com>
	 <1228658260.22164.41.camel@johannes.berg>
	 <445f43ac0812081017q2ac6ae1h84a86099518773cc@mail.gmail.com>
	 (sfid-20081208_191702_981904_BC48F1B6)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-67lS/ijmQd31TayD7T45"
Date: Mon, 08 Dec 2008 20:52:34 +0100
Message-Id: <1228765954.22164.117.camel@johannes.berg> (sfid-20081208_205312_104706_E82ECEA5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-67lS/ijmQd31TayD7T45
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-12-08 at 10:17 -0800, Javier Cardona wrote:

> To be useful for our mesh tests this "virtual air" would have to allow
> us to create 3 groups, each one a superset of the previous.  The
> smallest group would be the set of nodes that can a node communicate
> with ("A can talk to B").  The next larger group would be nodes on
> which a node that can interfere ("A can screw up C's reception").
> Finally, the largest would be nodes that can detect each other ("A can
> detect when D is transmitting").

That's something we can't actually simulate since you're trying to see
whether they do NAV updates correctly, right?

johannes

--=-67lS/ijmQd31TayD7T45
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJPXr+AAoJEKVg1VMiehFYn4oQAJwobw1BGlTY/2RTg8+Q7hw0
LcM2hMnUtEFi8pVWQB5Ad0wOG1WesndWbJSUdhEAqUa6mR+xX9l2MGBuv46392JV
B4MUjbH1i4nbNujwGG/ZLbRVnzcLJ+Th3nh/UggzJE33PdRA1fYkZKaQ88KltxrD
yMmVOFK11wxZKrNXKhdyCisTdnzc/z5ifmtVuIzSjpqw3nkdA7MhaGROM0lSSTqW
NQJ6G+iHC3lbOfyV5dElOgA/fBXeVMKAe5ZL3QG/T1udWRf9xA7orOtnNBdwJj66
k8vP/ahMhzYxQw1GgSFykTYkqUMJtKltWIQuF07VkFa+AwXBLJznA//stZqVZIpB
pCF1CwqM9pQdnpzUzA43qVoJgZpjOujkJrdnsxARZytm+y4c8QpG5bp/3Tmut9yk
LJaTPPmXmlcCzO7+ylrwiZmaNbJLEefDOu4WrEI8ckmD3Sr9XqG0bY40faVWwG25
jiBNEWOkWC/e1kevSOgzFzquhZjCjv1mAreuSU+24buDGUqDYlwjPa9lQ66N1VvD
OJq511sgTc168DmvYEk79TAylyHRMTeb34zL7Kme1QS3bP79unPYUhYy0oNNEJ9e
PH3yg3izFBD6rsy2E+TmgaCGVK03RMdIQUEFvvLYq6GfjguQ65H1Qv00TtvSXzat
MFXDhI2JPEh+G4nAnxG9
=LC57
-----END PGP SIGNATURE-----

--=-67lS/ijmQd31TayD7T45--


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:59482 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752953AbXH3FyU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Aug 2007 01:54:20 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Chr <chunkeey@web.de>
Subject: Re: Recent linux-wireless git changes have broken my prism54pci card
Date: Thu, 30 Aug 2007 01:52:23 -0400
Cc: Hans de Goede <j.w.r.degoede@hhs.nl>,
	linux-wireless@vger.kernel.org
References: <46BFF10B.1090307@hhs.nl> <46CEA8A2.3040906@hhs.nl> <200708282132.59474.chunkeey@web.de>
In-Reply-To: <200708282132.59474.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart7720558.5ZEkzIiboz";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200708300152.27736.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart7720558.5ZEkzIiboz
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tuesday 28 August 2007 15:32, Chr wrote:
> Here we are:
>
> series:
> p54-pull-padding2.diff
Looks okay, but it seems to do more than just account for padding. I'm okay=
=20
with those changes too.

> p54-support-older-firmwares.diff
The new information pulled from parsing the firmware isn't used anywhere bu=
t=20
in this function.. no need to keep that information in the private structur=
e.

Thanks,
=2DMichael Wu

--nextPart7720558.5ZEkzIiboz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBG1lsbT3Oqt9AH4aERAuXjAJ4z6Hop+iWGLej3/DscJyGt0kGUPQCgjaXg
8UYVm3mODfoKZmmO09xGzUM=
=6Iwq
-----END PGP SIGNATURE-----

--nextPart7720558.5ZEkzIiboz--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html

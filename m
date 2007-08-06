Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:52642 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168AbXHFJKz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2007 05:10:55 -0400
Subject: Re: [BUG] timer.h
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian =?ISO-8859-1?Q?Sch=E4fer?= <schaefer@in.tum.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-wireless@vger.kernel.org
In-Reply-To: <46B6DF83.8080507@in.tum.de>
References: <46B1F896.8090005@in.tum.de> <46B2EA43.8070305@in.tum.de>
	 <20070803123240.519c5a38.akpm@linux-foundation.org>
	 <1186382146.21957.40.camel@johannes.berg>  <46B6DF83.8080507@in.tum.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-6SRItHPv27g5i9Nn3NsP"
Date: Mon, 06 Aug 2007 11:12:44 +0200
Message-Id: <1186391564.28655.22.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-6SRItHPv27g5i9Nn3NsP
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-08-06 at 10:44 +0200, Christian Sch=C3=A4fer wrote:

> The driver source is from [1] (I think it comes from Realtek) and=20
> patched with the injection-patch taken from the aircrack-project (for=20
> more background see [2]).

Thought so. Can't help you with that.

> However this issue was before I used the current 2.6.23-rc2 kernel with=20
> native r8187 support where no such problem occurred untill today.

So? Even if you haven't gotten any debug printout before doesn't mean
the bug is new in the kernel. Andrew has already pointed out what the
bug is; I'm merely saying that we're not interested in fixing it because
it is vendor source and we have another driver 'rtl8187'.

johannes

--=-6SRItHPv27g5i9Nn3NsP
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGtuYM/ETPhpq3jKURAmq0AJ9VCTyoBUtLQnZlXuBNqouiFxWy+gCfSLM2
tOWa5yakk3fM6VTfu/IqT60=
=8xx9
-----END PGP SIGNATURE-----

--=-6SRItHPv27g5i9Nn3NsP--


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50558 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbXINMFr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Sep 2007 08:05:47 -0400
Subject: Re: iwlist and network-manager bug report
From: Johannes Berg <johannes@sipsolutions.net>
To: jt@hpl.hp.com
Cc: Dan Williams <dcbw@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1189667496.6161.77.camel@johannes.berg>
References: <1189526874.6161.30.camel@johannes.berg>
	 <1189610572.5644.28.camel@xo-3E-67-34.localdomain>
	 <20070912170153.GA25785@bougret.hpl.hp.com>
	 <1189667496.6161.77.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-8e8GAAnBJJBb/xKh/wKV"
Date: Thu, 13 Sep 2007 20:18:13 +0200
Message-Id: <1189707493.1329.1.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-8e8GAAnBJJBb/xKh/wKV
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-09-13 at 09:11 +0200, Johannes Berg wrote:

> Ok. I'll have to do some more extensive tests but in my last test with
> zd1211 it wouldn't display anything. Might be a different issue, but
> scanning manually showed things.

Cool, I was totally wrong, seems the fact that it didn't display
anything was unrelated. I just tried again and NM 0.6.5 as shipped by
debian/unstable actually manages to display the =C3=BC umlaut that is
supposed to be the \xfc character.

Btw. Will there ever be a 0.7 release? :)

johannes

--=-8e8GAAnBJJBb/xKh/wKV
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG6X7l/ETPhpq3jKURAl03AJ0TgPJl52ZxETYyCj/JmoO/GgXP9gCfR83k
tJUTlVtPxubWRWOuMYA4FU0=
=zq9b
-----END PGP SIGNATURE-----

--=-8e8GAAnBJJBb/xKh/wKV--


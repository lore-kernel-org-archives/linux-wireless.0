Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57260 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757131AbZARIsh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Jan 2009 03:48:37 -0500
Subject: Re: [PATCH 07/13] cfg80211: only export disable flag on channel
	disablement
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20090116210930.GL29609@tesla>
References: <1232064746-17134-2-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-3-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-4-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-5-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-6-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-7-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-8-git-send-email-lrodriguez@atheros.com>
	 <1232097827.3854.25.camel@johannes> <20090116163245.GF29609@tesla>
	 <1232138101.3745.7.camel@johannes>  <20090116210930.GL29609@tesla>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-9abJZlTuYZ1K9MiL6fNi"
Date: Sun, 18 Jan 2009 09:48:36 +0100
Message-Id: <1232268516.3877.10.camel@johannes> (sfid-20090118_094842_212569_BA127BE4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9abJZlTuYZ1K9MiL6fNi
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-01-16 at 13:09 -0800, Luis R. Rodriguez wrote:

> I can put a note, if that helps, or are you strongly opposed to this? :)
> Just an itch to scratch really, have you seen the output of iwlist on
> disabled channels? It can get long on radar/no-ibss channels. We can also
> handle this in userspace but seems pointles if the channels is disabled.

Well, come to think of it, at least for programmers it might be
confusing when they know they've put some flag into orig_flags, and then
it disappears? I'm not really _strongly_ opposed to this, but I really
just don't see the point :)

johannes

--=-9abJZlTuYZ1K9MiL6fNi
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJcuzhAAoJEKVg1VMiehFYbEoQAMOcvdt8c8mtBOztHjWamzym
/KF8XKxzeCjol99kF1rKjvv9II1h8WWELC9rq3d/+41QePtShB00RGpLcn4gUGLq
Cf8ausqDlDcnST2I0j3RJXoQ8vw1NoZ0JLYO2ekszs5j24QBlHvrSnzQkR+xIODc
7dLwdeSXAfl9VFZpru6NT2JWXhaaynob8WbOLufQTGVb3V0LlJhPbyD2fyZr8Uc3
HVb7T68Xboh6nj89vgy8Bj3Wd1Jlroyka2NY0w0s/bdNbSgjdwdq7hnzKENX8xQg
eJHz+lTifremL2pvVjW8SVwcwgiMvGQtMJO1B6LiTp4BaGI8H6lSKXuxNhh0mx88
j8/W+ORpSM2VldPfHKlqlgDUEk3r32M/NxWASBfnwCsa1noBXHrCztSaaWV2XetN
Gd0tvNjkiLGENyF4Yj1LjFYkpI74ksXkboUM2DRm5Saxc3Qlm9LMj3qn1/UTQ2KS
FmzR+7qGMDQe+1ldALQtZRzN6LcoCJRMTYe2u3on3yxFoZvAifm2Q0ngVsrZGrUS
KmCkBoHBRCFp9B4PIH7oUsej7hYfqDBmaN05UmgvY7Z1Bmc7Nch82v3sRt+Chayj
Lof4wpGAyVgT+imM4CMwkYkfUVzDDpQC4AnYL9BZliVOyw6rQTNS84QUo/qJ2js5
cdUtrWDQaRhRH5y8lvdD
=qqUK
-----END PGP SIGNATURE-----

--=-9abJZlTuYZ1K9MiL6fNi--


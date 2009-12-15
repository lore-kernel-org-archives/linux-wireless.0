Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from parez.praha12.net ([78.102.11.253]:58407 "EHLO
	parez.praha12.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760707AbZLOVX3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Dec 2009 16:23:29 -0500
From: =?utf-8?q?Luk=C3=A1=C5=A1_Turek?= <8an@praha12.net>
Reply-To: 8an@praha12.net
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [ath5k-devel] [PATCH 2/5] mac80211: Add new callback set_coverage_class
Date: Tue, 15 Dec 2009 22:23:27 +0100
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <1260899813-17585-1-git-send-email-8an@praha12.net> <1260899813-17585-3-git-send-email-8an@praha12.net> <20091215181149.GA2123@tux>
In-Reply-To: <20091215181149.GA2123@tux>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4064958.qUFVbbNJoy";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200912152223.27562.8an@praha12.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart4064958.qUFVbbNJoy
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On 15.12.2009 19:11 Luis R. Rodriguez wrote:
> Hm, it seems best to just add the capability bit that way userspace
> can stuff what it wishes and the kernel will only set what is supported.
> As is now this would lead to -EOPNOTSUPP but we'd have no way of knowing
> from userspace what failed.
I could add the capability bit, but I don't understand you completely - do =
you=20
mean the kernel should just ignore unsupported attributes and leave the=20
checks to userspace?

Lukas Turek

--nextPart4064958.qUFVbbNJoy
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iQIcBAABAgAGBQJLJ/5PAAoJEEBjvk/UOfYwIG0P/Ao+XlveIfrmUP305VEqOtGz
xW+Q256o6yHa4rXfXVrwlcSb14E8vlR2BeKQpxmS5IjiKbLoJ0TMhtJ2/4JrgkFz
g+3ak+4KbHFPlABpkZiY0vs2SofkE5NLBILKr8TJu1sO+sKTWbq/BK+LP1PlSO3T
mw6uUijdN/cTpCRtAwkrY26VcaWYmsZYOg/xHiWCgO/gfbDdFwKCy6EqMLXTLMqJ
bYkpD8CFkqjVGVMJOnN2GVkOTkt2dHxDrxv69PfOmb9Rb7nbOYn/JVZePgmmAhZg
qfKhRwjw5DbH95/ZBFAwI60tlE950vk85tMkQ8GCAJzzrQHIa7jW9jA12EyzbDM+
PZd7zrM4yA+Tbb4AznhYvug9RR2Elg9sqYnBC1SGOzB5W23S+cJ4hXlMjYOqucbb
LxNxUSQIW/7dhK1IviAnpsViPrNjAjEo4Yk4HITcH/Hp2fe8s/PP/lFpri7xJWVn
ttCiE8nVpi0Jb4XGNGcQNiM4kq0nWhXKlBP4+BWV/drggDeiiEifSOGzxRBf/osK
AEE8crBTxEPQiS+GsMWzLK4tlINfyrqgLQs85xlBcLsSBL6TspR7uyK6PvyDQcxt
NPYiKlBBr+781VtL1urB6mg/0nW2e9oorFzSKKTBvOfFKwt7Jjnz9nSwQPtq25uI
IRmE5V/GkM+cPy9L7aFn
=gTnX
-----END PGP SIGNATURE-----

--nextPart4064958.qUFVbbNJoy--

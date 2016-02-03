Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from narfation.org ([79.140.41.39]:54608 "EHLO v3-1039.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933137AbcBCRfc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2016 12:35:32 -0500
From: Sven Eckelmann <sven@narfation.org>
To: b.a.t.m.a.n@lists.open-mesh.org
Cc: Josh Boyer <jwboyer@fedoraproject.org>,
	Marek Lindner <mareklindner@neomailbox.ch>,
	netdev <netdev@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Kalle Valo <kvalo@codeaurora.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [B.A.T.M.A.N.] ibss.c backtrace when batman-adv adds wireless interface
Date: Wed, 03 Feb 2016 18:35:29 +0100
Message-ID: <66120881.3atMJx6hST@bentobox> (sfid-20160203_183552_739509_D1E20877)
In-Reply-To: <9390290.k4UIzlfAE4@bentobox>
References: <CA+5PVA4HVjsEw+j+HMDzO0gnQb4xTRwbAu4H2do3MU41QWvOvw@mail.gmail.com> <1454514090.3083.8.camel@sipsolutions.net> <9390290.k4UIzlfAE4@bentobox>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart42786321.4PaYx0Sem2"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart42786321.4PaYx0Sem2
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Wednesday 03 February 2016 18:09:40 Sven Eckelmann wrote:
> > AFAICT this should be a driver (or perhaps mac80211) issue, but I don't
> > see any information about the driver used.
> 
> It doesn't really look like it is batman-adv specific. batman-adv also doesn't
> be active because the message "batman_adv: bat0: Adding interface: " is
> missing.

Maybe I should clarify a little bit. I meant that that message is missing
before the problem happens. The interface message appears after the problem
was detected.

And maybe I should also inform you that many batman-adv refcounting
patches [1] for some long standing problems are getting queued up by the brave
linux-stable people. But there are also two patches [2,3] which Antonio hasn't
submitted yet.

Kind regards,
	Sven

[1] https://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.3.5-rc1.gz
[2] https://lists.open-mesh.org/pipermail/b.a.t.m.a.n/2016-January/014304.html
[3] https://lists.open-mesh.org/pipermail/b.a.t.m.a.n/2016-January/014305.html
--nextPart42786321.4PaYx0Sem2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJWsjphAAoJEF2HCgfBJntGTVsP/0Uty/nt7gaRFgeYkkMc/5JG
9eVSOjpIvfszElXo/45X40T4GjWgs/RU+xGYH+3cka6fjZDSmWyKbH4qiy38n5SR
uLyBX2UnFWdLJy+bdipO2QFgbOvBMAcq4TxiTYU04W3M/laxd72DV9dDqDEs21Cp
JhiqBl0iOgqIo27eIY+r2HlrmsutsIUERV2Fjj3Q8NZnut4ljMFpPBGe93ehWwzr
v2cnizM3do0MPDND01Tp/joU1QUCX+bzZxLjtmM+FOy493bQ2U09gfIxFepIXrO7
lIm1jCdmJwKynb/T92qBpdY5M8GFE79xF3WNhV4vbIPNkDP3+R8RkNZJanf8Mpgj
06jLBxK2W93U7E7aq4pleECHAOWxLLI8nDve+FVAB7QYasWTCDDBbl+3QvD6SIva
296tIsVOKI7KAkMXnNiMzx+u76xv5/1vrv955I5WrZYVbtbB9TX2xPRS2OPOBfdV
0wWAkKQnU/V2Akt0XRt7VPgmlmv5myxHrwIHlXAVhtk2zjXG/5D4SBxXsaymZTyZ
fidB6phN7TuMr+rbFyyE6c8TZI9+XsOqUC/uC2118iPrQ1cjDKoVwxdwuNmPRkyp
572/vOWQmGWADxpOIYRMV+9otrQ0Nl9fZQwBjOFxx24T6diDbc6BcZOzXPckCFQc
2GzRTBNZQaA71VmAyEcK
=ou9B
-----END PGP SIGNATURE-----

--nextPart42786321.4PaYx0Sem2--


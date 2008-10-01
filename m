Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38405 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411AbYJASUh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Oct 2008 14:20:37 -0400
Subject: Re: [PATCH 1/1] mac80211: send action frame when toggling SM PS
	mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
In-Reply-To: <1ba2fa240810010340t14dce3a0p46b834f39d66f6b2@mail.gmail.com> (sfid-20081001_124009_131930_02BDD0FA)
References: <1222618493-19019-1-git-send-email-tomas.winkler@intel.com>
	 <1222618769.7064.0.camel@johannes.berg>
	 <1ba2fa240809280924n1505e049w7800e3ef28449e8e@mail.gmail.com>
	 <1222619168.7064.3.camel@johannes.berg>
	 <1ba2fa240809280939x31829a25wa46948d1f351c7a0@mail.gmail.com>
	 <1222622474.7064.6.camel@johannes.berg>
	 <1ba2fa240810010340t14dce3a0p46b834f39d66f6b2@mail.gmail.com>
	 (sfid-20081001_124009_131930_02BDD0FA)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-2+ZKBOBS8s49fwynUFVO"
Date: Wed, 01 Oct 2008 20:20:28 +0200
Message-Id: <1222885228.7064.68.camel@johannes.berg> (sfid-20081001_202041_159340_EEFCDF57)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-2+ZKBOBS8s49fwynUFVO
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-10-01 at 13:40 +0300, Tomas Winkler wrote:

> >>  We
> >> > keep adding API in mac80211 and nobody really knows when to call it.
> >> > Maybe you should (maybe team up with Atheros for it) write a "HT
> >> > hardware with mac80211" chapter in the documentation?
> >>
> >> Yes we should.
>=20
> Fresh from Intel
> http://www.cambridge.org/catalogue/catalogue.asp?isbn=3D9780521885843

That documents how mac80211 does things? :)

johannes

--=-2+ZKBOBS8s49fwynUFVO
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI479oAAoJEKVg1VMiehFYr2gP/100kFN2NFyWAQNY53kxpITR
+byc9cMkEWqfuddysMnWubQqu8OjOxQxPl1JQuZImmLw9sL3k8/MwW9i6xLHx0Xo
aQcbykINVWyCh173g1DzlwgSGZj9dZ504FWIyJa7Yru6HsraTgMjxnA3GbIDirQP
X51FYCWGW1M30Qrt7GVUDlH35rAJi4FhQWdZVoVYgXcPstMnFm0p+K1+IcNaEYjA
si0sGLxjB3+LwJS3C6uajlSMA07RsFG3Dg9eYBzdwwE5cdZ7wyug8yc6Pny5d18d
tyz+85X9isQCw4bedeq8sX+TM5hLi8vt/dPj0ZmtCrxS9KTAnjg4myMvHu5F+nic
mxeqIHECKHLlrPuaIwLJtF6W7FjJhYYrcv8RznC13E9lBNGmTsnBGsPl6KHNeg06
WQ3oMVN8YmewAJmf9Cfh9dZGuakSOqItHwgKeo/prafi37QaA5kHkgLA5je5CLRs
q5iL+BqD4x/X6jsnvKT0hYkM5ARgf0HFZ11lotiGSYJ8U5B2k4oehBVagaZ164ea
qFiG5zS8NWVk7VAX1gUmHq6D/q5M5RNcMztjVrc0nIfrtqDqUysCExBrUAkmENLf
nu8FFERdYbpPGcbNHYwFWtkrKtMQdOLPWxzdzaXksI41StYtL6DBiulUdfkcFT6A
OSF0MWBsRxV9wTGlS5ai
=Px9o
-----END PGP SIGNATURE-----

--=-2+ZKBOBS8s49fwynUFVO--


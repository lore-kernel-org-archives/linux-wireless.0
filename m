Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58692 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676AbZEOIBj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 May 2009 04:01:39 -0400
Subject: Re: [RFC 3/5] mac80211: fix idle trigger upon resume
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890905141918v5c8aa7b9n2ab42bfabd90ca54@mail.gmail.com>
References: <1242033904-25694-1-git-send-email-lrodriguez@atheros.com>
	 <1242033904-25694-4-git-send-email-lrodriguez@atheros.com>
	 <1242036115.3284.15.camel@johannes.local>
	 <43e72e890905111134u61f1600fie1950b6e12681e13@mail.gmail.com>
	 <1242068010.3873.46.camel@johannes.local> <20090511190922.GD18696@tesla>
	 <20090515003202.GA17816@tesla>
	 <43e72e890905141833g214753d9lbdb00bd70ee28dfe@mail.gmail.com>
	 <43e72e890905141918v5c8aa7b9n2ab42bfabd90ca54@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-L+hmclx9qa2Ac4EdP9/1"
Date: Fri, 15 May 2009 10:01:10 +0200
Message-Id: <1242374470.5799.18.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-L+hmclx9qa2Ac4EdP9/1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-05-14 at 19:18 -0700, Luis R. Rodriguez wrote:

> >> So I've added the WARN_ON() here as we agreed to investigate on irc. T=
urns out
> >> we hit it several times as expected. We hit it while going to suspend
> >> once, and then on resume 3 times.

> Nevermind -- the last trace does show its called from disassoc -- and
> we I don't think we should disassoc until we've come back from
> suspend.

Yeah that bit is odd -- but like I said I think it's just the fact that
we don't cancel any of our timers or sync our work.

johannes

--=-L+hmclx9qa2Ac4EdP9/1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKDSE+AAoJEODzc/N7+QmaKSEP/08rTQNPlAB5q+pfhlCflPwq
YXVF0pppYCveRaH+3umPfL2Lv5IDaPNFtRBN2cX2iSYywaFqaqQu01g8eZ12fVHT
21GD6EYPYv3tfNRzzxHn/Y2QdvT9HwtnFPUyhisSuo3Wk8d5WG0FvTPNFbNJ30qn
GYG73mHBONOmb7bNXoOGmB3a+Y+9LsgX53aPbpQc6bKHQIr0vBKYk5EOyHaFckfZ
O9dBIY5O4VJQKLzYnYHf7NGP6kMENu3ZWMdoysiJOIPpuSoZtfyh58KFX6fkWlvs
reFkLWm+c5dUOXQpWmgu4rEjLBZQyTBUC7Q4Wc6gEvimxLsm4joFuO5XHvw1R/qE
7KfcortuiEzrLpgq+y/gCX25k1WD3Ip+jqFLcC8/jWPCZ+sA5AydWote9sFPbbQR
Rz8Mw7/XeI2eNDIR9yBvnxtfXeAf0V6VXdfhXcAxUPv72jGpCkSP1LyIXMBWcdbJ
4kBvFwURjH2XeRSYsM+VzMhvdw8o7tRrMNsGajXrwAP81nTzf0HvkPKS26/0ojBt
nte8RUZqxaT49jmx/zoPgVxrrOCA4XQu6vKjN/7YVD/6boTITdyFqIxYbhYRnxiK
3ZnYOawE2WrGxyIj9uZio0983mUtkl4v4lBmpbQR+ZynVnkXdFbKUsi2GBc7xhQR
G18tkTBL9ZoszcKPFjHN
=cANB
-----END PGP SIGNATURE-----

--=-L+hmclx9qa2Ac4EdP9/1--


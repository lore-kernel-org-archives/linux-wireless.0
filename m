Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53941 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbZDXJYR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Apr 2009 05:24:17 -0400
Subject: Re: [PATCH] mac80211: add driver ops wrappers
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <87y6tqd32q.fsf@litku.valot.fi> (sfid-20090424_073822_071232_0014077F)
References: <1240505572.30082.233.camel@johannes.local>
	 <87y6tqd32q.fsf@litku.valot.fi> (sfid-20090424_073822_071232_0014077F)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-QqZFeHERUzBTVN/7C06a"
Date: Fri, 24 Apr 2009 11:23:39 +0200
Message-Id: <1240565019.5066.2.camel@johannes.local> (sfid-20090424_112420_537963_BD89FC62)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-QqZFeHERUzBTVN/7C06a
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-04-24 at 08:37 +0300, Kalle Valo wrote:

> But I'm just concerned about the drv prefix, with very bad luck it might
> create conflicts with some other component. What about using
> ieee80211_drv, for example?

Hmm. I kinda share your concern, but since these are all static inlines
they don't really pollute any namespace, at least not for linking, so
conflicts could only arise when another subsystem suddenly exports the
same name, in a header file that we include. In the end I decided not to
worry about it just because it otherwise gets very long.

johannes

--=-QqZFeHERUzBTVN/7C06a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ8YUSAAoJEKVg1VMiehFYZ0IQAKhE0IY14bLZSu9nCsNIGqr+
bB6+67mu0wD30VqBleGPmU3sYLl6Ta+N2enKY++E97n8DQ57AZmU3pSf/NBVmJks
aPGl/1crjFYR78y+vthOVouJtbMnFwH7EWGU2OLYGVwHnZ9AU1fNmGVsJklm6DCs
Nh6CmDR1CqtvN2Yatg7gNt/VBSpSAatgcwnRy5H+Rvzy8SOzZRlQAlkBVaHTvMMe
YRungzLwUvQxEjOWuznHfP4fOPwmFDyPcuDlQVj8iMU6Gl4gNOy2Png6UiGgCcSP
pj0MFRHeqXbVKBGRupgIlLBt2LnEAUdXcTnQPnYaaEC16GSLyIGj2m+d9d0+rPL6
0HvLUNMz6BDE5Ec8nlsFiB2MKYKjwyCgsQ7rKzAxDszrj/eF8GprF+Wf3OLqENz6
N1VEw8ulj9goH6bvLGipDl/N9toUJa3jNXlG33Mpg4nXnC0TkUC+tXK62SRbedXp
Pn1WCqQdjNtHoSsKholRO1qCC1r6UGq4SHb0UgF44tDGSveVbq3seDuKEpTV67Ah
Tzvf+719i3N4ivDqzl5FwaEQ5ICp2pJJ4qYiiGK9tNrOjjn2GOVhgzL6kfeRGLum
5oZd1jaVFnLUTdA0H9+xpuatsI6q/5HZd5udD4WGHUG/5VcbTOS1vYaAi1IlruxC
dydJ0UxFUrRKiS1Y2n2m
=JoiY
-----END PGP SIGNATURE-----

--=-QqZFeHERUzBTVN/7C06a--


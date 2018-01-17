Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from narfation.org ([79.140.41.39]:56204 "EHLO v3-1039.vlinux.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752068AbeAQQDB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Jan 2018 11:03:01 -0500
From: Sven Eckelmann <sven@narfation.org>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Subject: Re: [1/2] mt76: fix possible NULL pointer dereferencing in mt76x2_ampdu_action()
Date: Wed, 17 Jan 2018 16:56:46 +0100
Message-ID: <9978263.24XfVAzbPX@bentobox> (sfid-20180117_170306_150118_166D3506)
In-Reply-To: <87o9lsczf4.fsf@kamboji.qca.qualcomm.com>
References: <18a56326d68a7d53f3197e450cae0e28382d8d2c.1513252573.git.lorenzo.bianconi@redhat.com> <5835442f-9e10-69bb-3b6d-d207d540181f@nbd.name> <87o9lsczf4.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart8025479.GqWdGYHKZd"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart8025479.GqWdGYHKZd
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Mittwoch, 17. Januar 2018 16:50:23 CET Kalle Valo wrote:
[...]
> >> I didn't see Felix's ack, at least not on patchwork.
> >
> > I sent my ack (for both patches) as a reply to 0/2
> 
> Ah. patchwork is annoying as it doesn't show the cover letter at all so
> I missed that.

Newer version at least can track the series and their cover letters. This is 
not completely what you want but at least there is hope. Here is an example: 
https://patchwork.open-mesh.org/cover/17240/ (you can use "Related" to see all 
the patches in the series).

Kind regards,
	Sven
--nextPart8025479.GqWdGYHKZd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAlpfcj4ACgkQXYcKB8Em
e0azVQ//UozFchriLSAsK4GdjGy6MZkfJxWbUVYY8LcOMZ+sDiGnxZbe8p8U+QFH
Agm27i+/Xb8gqEvsonx2edRuqRt7UmBAC2eS/HRu3UO7PMW8bMEhsbVShTydIT3/
Yv5tfYe59SXM5cpQ04Y9Y3MHgzh5UvxwwsXIskE94jDgL9my8a0+rtHLMaN4fYgY
nmEfDxfO5XBcW4j/+BXkYVGFI/NcXJsbNK/1PMpBuVFPf9KW+Snzxqm5J+dREI+0
kw4CvlWOP43dPTsOtIb2NMgd+Ht26Y6Ih3C3XQAI6exvNG9q4EGtgvD6rMBAU5t2
8TP0TKdHQIPB8o/HNSydRIdERST0JeuLOpuwH8WL29IhM4Tz0x5DZ1DtyOSSdOue
rJn3nGi72xmkErjAGPHpjSIPmntDRDGYPVKzCVTYZxYn2q1/I2PDPrLjNOcW/ulW
9SvIpD8aKK4oNk68qWoKiEVcVavM0iE9Lyz2DroDq8h2Zq4tXouetgFj+fsLJrlz
AHiJcGKkKh5X0aw+is7sBDOdmSZWORT/6snm7CS+IlxuqgJAyJw5ttHtaI/hfKjU
/I6SpD3PTEKRcoYJtuyeBtl9VSa2ZMGbpO9rvlC0AJEQJ492YwRE6nAxq/nZ2fdC
8zBKSD2hBwG2f+WRwhOhmEzvMrFkk/XBmp1CbJvqFq185+s0AOQ=
=Qh+d
-----END PGP SIGNATURE-----

--nextPart8025479.GqWdGYHKZd--

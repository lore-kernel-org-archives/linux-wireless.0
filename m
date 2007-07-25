Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:9793 "EHLO annwn14.rutgers.edu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751294AbXGYEiv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2007 00:38:51 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: mabbas <mabbas@linux.intel.com>
Subject: Re: 11n in mac80211
Date: Tue, 24 Jul 2007 21:36:55 -0700
Cc: linux-wireless@vger.kernel.org
References: <46A64B7B.2070406@linux.intel.com>
In-Reply-To: <46A64B7B.2070406@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3754702.OlX2VI4Sm2";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200707242137.03423.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart3754702.OlX2VI4Sm2
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tuesday 24 July 2007 11:56, mabbas wrote:
> I am restarting discussion on how to
> improve these patches, or come up with new one, to add 11n support in
> mac80211.
Sure. The best way would be to submit patches. I suggest posting the patch(=
es)=20
for just A-MSDU frame aggregation (against upstream mac80211) to start sinc=
e=20
that will probably be the least controversial. I will review it.

Thanks,
=2DMichael Wu

--nextPart3754702.OlX2VI4Sm2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGptNvT3Oqt9AH4aERAvn4AKCI12oFzC7tFeEb+pZmzP/sXUlUlQCfXsNc
KHjPZ7+cM0LMx2f2ow8C/I8=
=LBeZ
-----END PGP SIGNATURE-----

--nextPart3754702.OlX2VI4Sm2--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html

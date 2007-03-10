Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:11965 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752848AbXCJRvR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Mar 2007 12:51:17 -0500
From: Michael Wu <flamingice@sourmilk.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH v2] d80211: Add software sequence support
Date: Sat, 10 Mar 2007 12:51:02 -0500
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Jiri Benc <jbenc@suse.cz>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200702141423.27823.IvDoorn@gmail.com> <1171914770.15489.5.camel@johannes.berg> <200703101538.55267.IvDoorn@gmail.com>
In-Reply-To: <200703101538.55267.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3661060.3cSgG0DYFQ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200703101251.07345.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart3661060.3cSgG0DYFQ
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Saturday 10 March 2007 09:38, Ivo van Doorn wrote:
> So just to be clear, this patch does not need any tweaking anymore right?
Just stick the counter in sdata if you haven't done so already. Should be f=
ine=20
once that's done.

Thanks,
=2DMichael Wu

--nextPart3661060.3cSgG0DYFQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBF8vALT3Oqt9AH4aERAu8QAJ9RnajuvRt9i8BEMvxEzNAEGD6vOgCgreFl
hq87NrEg60SsnKJZZIwSJXc=
=H3XD
-----END PGP SIGNATURE-----

--nextPart3661060.3cSgG0DYFQ--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html

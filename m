Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:60854 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755634AbXERXYJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 May 2007 19:24:09 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH]  Add iwlwifi wireless drivers
Date: Fri, 18 May 2007 16:22:22 -0700
Cc: James Ketrenos <jketreno@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <464B7B7C.5080800@linux.intel.com> <20070518230551.GB29062@infradead.org>
In-Reply-To: <20070518230551.GB29062@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5045795.rQvsHOYJ4M";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200705181622.27464.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart5045795.rQvsHOYJ4M
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 18 May 2007 16:05, Christoph Hellwig wrote:
> On Wed, May 16, 2007 at 02:45:32PM -0700, James Ketrenos wrote:
> > drivers/net/wireless/mac80211/Kconfig              |    1 +
> > drivers/net/wireless/mac80211/Makefile             |    1 +
> > drivers/net/wireless/mac80211/iwlwifi/Kconfig      |   96 +
> > drivers/net/wireless/mac80211/iwlwifi/Makefile     |   27 +
> > drivers/net/wireless/mac80211/iwlwifi/base.c       | 8146
>
> You're not reading linux-wireless a lot, are you?  The last
> driver submission got a pretty clear answer that there should not
> be a drivers/net/wireless/mac80211/ subdirectory.
>
This is just for wireless-dev. When it's being pushed for wireless-2.6 and=
=20
upstream it should go away then.

=2DMichael Wu

--nextPart5045795.rQvsHOYJ4M
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGTjUzT3Oqt9AH4aERAnvbAJ4hIWezKvmRA2dDEk2pk9CeJIOGswCfU5n1
gvCElWafPCkhPFTaTZjRklo=
=Pjz+
-----END PGP SIGNATURE-----

--nextPart5045795.rQvsHOYJ4M--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html

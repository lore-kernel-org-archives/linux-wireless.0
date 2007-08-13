Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:51004 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754843AbXHMGU3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Aug 2007 02:20:29 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Hans de Goede <j.w.r.degoede@hhs.nl>
Subject: Re: Recent linux-wireless git changes have broken my prism54pci card
Date: Sun, 12 Aug 2007 23:18:37 -0700
Cc: linux-wireless@vger.kernel.org
References: <46BFF10B.1090307@hhs.nl>
In-Reply-To: <46BFF10B.1090307@hhs.nl>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4695948.1SlfObM6MQ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200708122318.42283.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart4695948.1SlfObM6MQ
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Sunday 12 August 2007 22:50, Hans de Goede wrote:
> Patch causing loose off connection within seconds when fully loading the
> link with a local file transfer:
> http://bu3sch.de/gitweb?p=wireless-dev.git;a=commitdiff;h=62ee473d67b7ae353
>d210b186abaadc37a642237
>
> Only associating and nothing else:
> http://bu3sch.de/gitweb?p=wireless-dev.git;a=commitdiff;h=7d59453a9dbe50dc9
>bab846c410e39f8d5b10c83 And then specifically the changes to prism54common.c
>
Links not working.

-Michael Wu

--nextPart4695948.1SlfObM6MQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGv/fCT3Oqt9AH4aERAmi5AKCFD3lovg6SpKNFoQx63nPKABAAmwCfXL0M
AaDyHECe8FIuNolKKARWp/s=
=dTU8
-----END PGP SIGNATURE-----

--nextPart4695948.1SlfObM6MQ--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html

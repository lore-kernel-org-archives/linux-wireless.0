Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:12669 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932974AbXBUBZv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Feb 2007 20:25:51 -0500
From: Michael Wu <flamingice@sourmilk.net>
To: Pavel Roskin <proski@gnu.org>
Subject: Re: [PATCH] rt2x00: Fix max_rssi values signedness bug
Date: Tue, 20 Feb 2007 20:25:27 -0500
Cc: Michael Buesch <mb@bu3sch.de>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200702202102.14354.mb@bu3sch.de> <1172020729.6042.2.camel@dv>
In-Reply-To: <1172020729.6042.2.camel@dv>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1777872.oU9DeXhpcy";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200702202025.33485.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1777872.oU9DeXhpcy
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Tuesday 20 February 2007 20:18, Pavel Roskin wrote:
> > /* Maximum values for various statistics.
> >  * Leave at 0 to indicate no support. Use negative numbers for dBm. */
> > char max_rssi;
> > char max_signal;
> > char max_noise;
>
> So, there will be no dBm on PowerPC.  I think those fields should be
> "signed char".
Like in the patch Michael Buesch posted right before this one?

-Michael Wu

--nextPart1777872.oU9DeXhpcy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBF25+NT3Oqt9AH4aERAqBbAKDbuhtn25fSR3kXATu8qQYcXCrG6wCdErsM
73bsAyAGu3CLuf3ZtM7vGF4=
=/6Zo
-----END PGP SIGNATURE-----

--nextPart1777872.oU9DeXhpcy--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html

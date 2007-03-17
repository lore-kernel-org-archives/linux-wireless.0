Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:56294 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933045AbXCQFGT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Mar 2007 01:06:19 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Pavel Roskin <proski@gnu.org>
Subject: Re: prism54pci fails to read eeprom on PowerPC, then bugs in pci code
Date: Sat, 17 Mar 2007 01:05:18 -0400
Cc: Paul TBBle Hampson <Paul.Hampson@pobox.com>,
	linux-wireless@vger.kernel.org
References: <20070317034607.GA1522@keitarou> <200703170037.14875.flamingice@sourmilk.net> <1174107032.17023.14.camel@dv>
In-Reply-To: <1174107032.17023.14.camel@dv>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart6549716.gGmfMxjQhk";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200703170105.19348.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart6549716.gGmfMxjQhk
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Saturday 17 March 2007 00:50, Pavel Roskin wrote:
> Oh, and I'm amazed that somebody is using dadwifi-openhal verify the
> hardware!  It's in a pretty poor shape right now.  It prints some
> warnings because it starts with channel 0.  The interface can be brought
> up if you set a valid channel, and I think it might scan.
>
Really? mac80211 should set the channel immediately after bringing the=20
interface. If no channel is configured, it defaults to the first channel in=
=20
the first mode that is registered.

=2DMichael Wu

--nextPart6549716.gGmfMxjQhk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBF+3cPT3Oqt9AH4aERAiMVAKCmR5hCBc3IBRYQJKfeK8boc8dhJACeODwP
pRBAc/TSwyR9isSHQep6hOY=
=1trD
-----END PGP SIGNATURE-----

--nextPart6549716.gGmfMxjQhk--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html

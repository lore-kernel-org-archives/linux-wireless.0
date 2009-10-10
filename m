Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lennier.cc.vt.edu ([198.82.162.213]:59248 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbZJJFXU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Oct 2009 01:23:20 -0400
To: Zhu Yi <yi.zhu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: mmotm 2009-10-09-01-07 - iwl3945 fails to do firmware load request
In-Reply-To: Your message of "Sat, 10 Oct 2009 08:42:35 +0800."
             <1255135355.3719.22.camel@debian>
From: Valdis.Kletnieks@vt.edu
References: <200910090830.n998Ubvv020464@imap1.linux-foundation.org> <16108.1255133561@turing-police.cc.vt.edu>
            <1255135355.3719.22.camel@debian>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1255152144_250202P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Date: Sat, 10 Oct 2009 01:22:24 -0400
Message-ID: <252795.1255152144@turing-police.cc.vt.edu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--==_Exmh_1255152144_250202P
Content-Type: text/plain; charset=us-ascii

On Sat, 10 Oct 2009 08:42:35 +0800, Zhu Yi said:

> The firmware loading happens when the user space brings the interface
> up. Can you check NM is running for the bad case?

I'm not using NM, because I've never figured out how to get it to DTRT for
my network config, so I run wpa_supplicant directly.  It's looking like
a bad update to dbus was the actual root cause.

(Did I mention how I loath dbus?  Or at least the fact that if it breaks,
everything from wireless to pulseaudio immediately craps out too.  That and
'hald' are my two favorite "only on this laptop because stuff refuses to
work without them"....)

--==_Exmh_1255152144_250202P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFK0BoQcC3lWbTT17ARAhFMAKDJ2ReXz//1q9KFawFaDkdeJSmvbgCeOuwN
V8K6LJF+xKnfAkVgzbkCmhU=
=ULSW
-----END PGP SIGNATURE-----

--==_Exmh_1255152144_250202P--


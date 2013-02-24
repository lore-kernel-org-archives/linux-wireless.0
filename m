Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vms173011pub.verizon.net ([206.46.173.11]:34998 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759410Ab3BXDal (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Feb 2013 22:30:41 -0500
Received: from odin.tremily.us ([unknown] [72.68.84.219])
 by vms173011.mailsrvcs.net
 (Sun Java(tm) System Messaging Server 7u2-7.02 32bit (built Apr 16 2009))
 with ESMTPA id <0MIP00DPEDM8OI90@vms173011.mailsrvcs.net> for
 linux-wireless@vger.kernel.org; Sat, 23 Feb 2013 20:30:27 -0600 (CST)
Date: Sat, 23 Feb 2013 21:30:08 -0500
From: "W. Trevor King" <wking@tremily.us>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: arend@broadcom.com, linux-wireless@vger.kernel.org,
	brcm80211-dev-list@broadcom.com
Subject: Re: [RFC 12/13] brcmsmac: add support for probe response template
Message-id: <20130224023008.GG1361@odin.tremily.us> (sfid-20130224_043050_999702_5E3F2A21)
References: <1361667972-22909-1-git-send-email-hauke@hauke-m.de>
 <1361667972-22909-13-git-send-email-hauke@hauke-m.de>
MIME-version: 1.0
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="2E/hm+v6kSLEYT3h"
In-reply-to: <1361667972-22909-13-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--2E/hm+v6kSLEYT3h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 24, 2013 at 02:06:10AM +0100, Hauke Mehrtens wrote:
> The ucode is able to answer probe response by itself. This writes such
> a template into the specific memory. Currently the probe requests are
> also send to mac80211 so there are more answers send to a requesting
> client. We have to make the ucode stop sending probe requests to the
> driver.

Should this read "so there are more answers sent to"?

--=20
This email may be signed or encrypted with GnuPG (http://www.gnupg.org).
For more information, see http://en.wikipedia.org/wiki/Pretty_Good_Privacy

--2E/hm+v6kSLEYT3h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRKXstAAoJEEUbTsx0l5OM6xIP/A1C5klrNWq6sLmYWQedSB6v
/Ymd3YLYBZg9YXyJVGwmSv7/W9cxVcGLahdlynIe1pFS+rOZG3sG0IjsdVif5tFb
Jevtlz0gsHQ8IPw2VGyCkdBfXi/lGRoO9Zayp75Zs4ukhd416NZwoXDKsC5h0tjq
WEsqdxIQqJlUbsUww1zr/9szzrEKvyO53TwRwRV+hSWirHh4R46dRwBu4O0FF6f2
wxvRXxm72mWXuNfXmLRflZkg8P2hYU+ixoAk1X30BBMMeVUHDGWiEqVH6qJKCI+I
0DUMflRo6xo1o3tXmTXkEgAJlo0vK7I8a3hsaE/o/QJ/s1UHnxGA04cWAq1sN5xK
g0vPhckLPvuBpn2MhLik3OieBvmIVrG2HvCLuqnd6lYCF9yihv7m1X9AcN8yLhIA
+i+ByXg/mJQmjvfxwNiMeV8UCKtKV13CqvQAb9WTJ2sXlIPfUI8M+xYULhA1zw96
3TpsDwxMMqgTFBcc17CBdW0inNtAqkebNEL+uPxbDwgoo9O/iRVMEM7Qi+18c8Ju
bfYAwrdX4pN0L0LaiFSzS3pYz060loDEpsu+31pkLO1MpmweTyQl9jwWIS7OY+DM
fLIryiGfyAVbUKJn8VkSiYxkfEmwzAribPExqwE7sjh8UBKHvpximOAhx/xVnZpE
wFx95bXflkxIdIQmleFc
=Xc3l
-----END PGP SIGNATURE-----

--2E/hm+v6kSLEYT3h--

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47571 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757918Ab2FZQ1O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 12:27:14 -0400
Received: by eaak11 with SMTP id k11so58208eaa.19
        for <linux-wireless@vger.kernel.org>; Tue, 26 Jun 2012 09:27:13 -0700 (PDT)
From: Mariusz Fik <fisiu82@jabster.pl>
To: linux-wireless@vger.kernel.org
Subject: Intel N 1030 desn't connect to AP with WPA2 | Linux 3.4.2
Date: Tue, 26 Jun 2012 18:27:09 +0200
Message-ID: <2073595.T30nNVXCf4@pendrak> (sfid-20120626_182719_237485_C45FA59E)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart20631156.jZn3OH1Oub"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--nextPart20631156.jZn3OH1Oub
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi,

I installed openSUSE 12.2 Beta 2 with linux 3.4.2 recently and my wifi card 
has problems with connecting to AP with WPA2. Hardware I have:
| 02:00.0 Network controller [0280]: Intel Corporation Centrino Wireless-N 
1030 [8086:008a] (rev 34)

After boot I connected to my AP and wifi worked fine. After few seconds 
connection was disconnected and nm asked me again for password. Every try of 
connection was unsuccessful since now. `dmesg`, in the time of trying to 
connect, gives me:
| [  434.134710] wlan0: authenticate with 00:22:15:0b:55:a3
| [  434.143822] wlan0: direct probe to 00:22:15:0b:55:a3 (try 1/3)
| [  434.344492] wlan0: direct probe to 00:22:15:0b:55:a3 (try 2/3)
| [  434.545185] wlan0: send auth to 00:22:15:0b:55:a3 (try 3/3)
| [  434.745882] wlan0: authentication with 00:22:15:0b:55:a3 timed out
| [  434.747111] iwlwifi 0000:02:00.0: ACTIVATE a non DRIVER active station id 
0 addr 00:22:15:0b:55:a3

Full dmesg is available here: http://wklej.org/hash/1dc3164fa7/

Any hints about solving it?
-- 
Pozdrawiam / Best regards,
Mariusz Fik
openSUSE Community Member
GPG: 5FCE 7241 B3B9 32FD 455B C30E 42D6 6C88 9E83 7C3D
--nextPart20631156.jZn3OH1Oub
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iEYEABECAAYFAk/p4t0ACgkQQtZsiJ6DfD1NDQCg3EYkgVlze7DVAvA230UDvzeZ
9sAAnjBS2/hBMhm5PI0fpplnmSgtx7lR
=5Vel
-----END PGP SIGNATURE-----

--nextPart20631156.jZn3OH1Oub--


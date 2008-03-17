Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:34340 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400AbYCQIAa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Mar 2008 04:00:30 -0400
Received: by wa-out-1112.google.com with SMTP id v27so6244405wah.23
        for <linux-wireless@vger.kernel.org>; Mon, 17 Mar 2008 01:00:27 -0700 (PDT)
Message-ID: <47DE2517.9070601@gmail.com> (sfid-20080317_080045_786637_D26A2A52)
Date: Mon, 17 Mar 2008 01:00:23 -0700
From: "Tanner \"Xero\" Ezell" <tanner.ezell@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Intel 4965AGN and 802.11n
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hello all,

I've been trying for the last few days to get .11n support working on my
Thinkpad with the 4965 card to no avail, i have downloaded, compiled and
ran the kernel from wireless experimental git repo, and although i
enabled it in the configuration, when loaded, (modprobe iwl4965
qos_enable=1) dmesg reports "Tunable channels" to 802.11bg and 802.11a,
but no n. is there something special i must do? Is there a guide or
anything anywhere to get 11n support working at all? I'm using ubuntu
7.10 and have tried the compat-wireless package to no avail.

Any help would be most appreciated!

Tanner Ezell
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFH3iUXonMdW/6mR2YRAoJLAJ4k0BW5TG1/EgoMSa06BKel8dV7PACePIMW
mllwSoJ1lyFvD9YOQCw8W2Q=
=5izy
-----END PGP SIGNATURE-----

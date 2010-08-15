Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:35187 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758413Ab0HOQHJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Aug 2010 12:07:09 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1OkXrU-0001yP-Gz
	for linux-wireless@vger.kernel.org; Sun, 15 Aug 2010 09:42:32 +0200
Received: from rain.gmane.org ([80.91.229.7])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 15 Aug 2010 09:42:32 +0200
Received: from marcus by rain.gmane.org with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 15 Aug 2010 09:42:32 +0200
To: linux-wireless@vger.kernel.org
From: Marcus Better <marcus@better.se>
Subject: iwl3945 not associating on 2.6.35
Date: Sun, 15 Aug 2010 09:42:15 +0200
Message-ID: <i485ou$qmb$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi,

after upgrading from 2.6.34 to either 2.6.35 or 2.6.35.1, wpasupplicant will 
no longer associate to my WPA2 access point. The log is full of "Failed to 
initiate AP scan" messages.

Is this a known issue? I couldn't quite find out by sifting through the 
archives... The system is a Thinkpad T61, x86_64, Debian sid, network-
manager and wpasupplicant 0.6.10-2.

Cheers,

Marcus
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkxnmlcACgkQXjXn6TzcAQnMGACfWGBirSDBKoTpgC0wbvVprU3W
U3wAmgKGiivAZdln14CdkBWIF2hJd+BS
=84Cy
-----END PGP SIGNATURE-----



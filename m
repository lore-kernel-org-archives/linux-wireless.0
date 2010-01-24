Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:37544 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752837Ab0AXKcr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Jan 2010 05:32:47 -0500
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1NYzls-0005oI-FY
	for linux-wireless@vger.kernel.org; Sun, 24 Jan 2010 11:32:44 +0100
Received: from rain.gmane.org ([80.91.229.7])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 24 Jan 2010 11:32:44 +0100
Received: from marcus by rain.gmane.org with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 24 Jan 2010 11:32:44 +0100
To: linux-wireless@vger.kernel.org
From: Marcus Better <marcus@better.se>
Subject: Re: mac80211: Breakage in software encryption (iwl3945)
Date: Sun, 24 Jan 2010 11:32:19 +0100
Message-ID: <hjh7jk$7nb$1@ger.gmane.org>
References: <1264277460.13250.10.camel@maxim-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Maxim Levitsky wrote:
> I updated the kernel and lost connection to my WPA2
> AP. Strangely the WPA handshake completes, but DHCP not.

I have observed this a few times with 2.6.32.4. I could work around it by 
unloading and re-loading iwl3945.

> Now, the commit a6bae9e7ab19876a157c91019852395539e4f20e breaks software
> encryption, with behaviour like described above.

I don't think 2.6.32.4 includes that commit though.

Cheers,

Marcus
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktcIbMACgkQXjXn6TzcAQl0TQCg3IumaU/tB0N+yld2dg6weJG4
+IAAoO19+HFQuQRKBvm8wsKVl43tUET6
=4lgK
-----END PGP SIGNATURE-----



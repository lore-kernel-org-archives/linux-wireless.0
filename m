Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:60195 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751438Ab0AXLPs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Jan 2010 06:15:48 -0500
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1NZ0RW-00070v-Av
	for linux-wireless@vger.kernel.org; Sun, 24 Jan 2010 12:15:46 +0100
Received: from rain.gmane.org ([80.91.229.7])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 24 Jan 2010 12:15:46 +0100
Received: from marcus by rain.gmane.org with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 24 Jan 2010 12:15:46 +0100
To: linux-wireless@vger.kernel.org
From: Marcus Better <marcus@better.se>
Subject: Re: mac80211: Breakage in software encryption (iwl3945)
Date: Sun, 24 Jan 2010 12:15:14 +0100
Message-ID: <hjha44$fr6$1@ger.gmane.org>
References: <1264277460.13250.10.camel@maxim-laptop> <hjh7jk$7nb$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Marcus Better wrote:
> Maxim Levitsky wrote:
>> I updated the kernel and lost connection to my WPA2
>> AP. Strangely the WPA handshake completes, but DHCP not.
> 
> I have observed this a few times with 2.6.32.4. I could work around it by
> unloading and re-loading iwl3945.

Oh, and I should say that I didn't see this with 2.6.31.6.

After the WPA handshake completed, I ran tcpdump and could see the outgoing 
DHCP requests, but no other traffic on the interface.

Cheers,

Marcus
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktcK8IACgkQXjXn6TzcAQkRowCgpObrzU7e1tYuY08nzQYE3yKS
NycAoO6rdlFkZeqm37fs3nYwD22pI8Qq
=TjWE
-----END PGP SIGNATURE-----



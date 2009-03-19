Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f165.google.com ([209.85.219.165]:51279 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756492AbZCSX3B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Mar 2009 19:29:01 -0400
Received: by ewy9 with SMTP id 9so570590ewy.37
        for <linux-wireless@vger.kernel.org>; Thu, 19 Mar 2009 16:28:58 -0700 (PDT)
Message-ID: <49C2D537.6080406@giuppi.com> (sfid-20090320_002905_361437_A0137045)
Date: Fri, 20 Mar 2009 00:28:55 +0100
From: "Info[at]Giuppi" <info@giuppi.com>
MIME-Version: 1.0
To: Hin-Tak Leung <hintak.leung@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: rtl8187 bug report
References: <49C12DFA.80308@giuppi.com> <3ace41890903191439q1c375925md2e4227f79147399@mail.gmail.com>
In-Reply-To: <3ace41890903191439q1c375925md2e4227f79147399@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1
 
Hin-Tak Leung ha scritto:
>
> I am not familiar with aircrack-ng, but I believe it can be used with
> a modified version of the vendor rtl8187 driver, (and the aircrack-ng
> people hosts a modified version of the vendor driver on their web
> site). I have not actually looked at their modification so I have no
> idea what modification is required for aircrack-ng to work well, but I
> believe *some* adaptation is required?
RTL8187B has no official linux support by the vendor. The driver
you're referencing to has been adapted by one guy and "works" for old
kernel versions only.
I'm very happy with this new rtl8187. The problem in not related to
the aircrack-ng software. I'm just saying I think there's something
wrong with WEP networks in monitor mode. Using a tool from the suite
to scan local wireless networks I've found out that strange behaviour
only with WEPs.
>
> On a different issue - I think such adaptation are frown upon and will
> not make it into the standard kernel, due to its nature of typical
> usage in a controversal scenario. Maybe other wireless dev people,
> especially Herton and Larry, can advise.
As far as I know there are no adaptations needed. Wanted or not, it
already works in those "controversal scenario".
The rt73usb driver comes from the same compat-wireless package and it
hasn't that problem, for example. The rtl8187 driver itself works
great for networks other than WEP.

Thanks very much for your reply, I hope some of the devs can take the
time to check if I'm wrong.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org
 
iEYEARECAAYFAknC1S8ACgkQzDOyiWU13FC8AgCdG2mv/xMPGIg13YsM9o3V5ZeT
e4AAn16SMsX081bPc4eK9RdddMZ3Nu01
=vAo1
-----END PGP SIGNATURE-----


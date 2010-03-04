Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from m-04.th.seeweb.it ([217.64.195.227]:60364 "EHLO
	m-04.th.seeweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753619Ab0CDKNR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Mar 2010 05:13:17 -0500
Message-ID: <4B8F87B6.9060901@users.sourceforge.net>
Date: Thu, 04 Mar 2010 11:13:10 +0100
From: "Daniele C." <legolas558@users.sourceforge.net>
MIME-Version: 1.0
To: Hin-Tak Leung <hintak.leung@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: rt2870 (staging kernel driver) crashes fatally
References: <4B8E20CF.50109@users.sourceforge.net> <3ace41891003031814r73d3b615x99d29e9cad1fd9c4@mail.gmail.com>
In-Reply-To: <3ace41891003031814r73d3b615x99d29e9cad1fd9c4@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

- -------- Original Message  --------
Subject: Re: rt2870 (staging kernel driver) crashes fatally
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Daniele C. <legolas558@users.sourceforge.net>
Date: Thu Mar 04 2010 03:14:38 GMT+0100 (CET)

> You appear to have two issues - (1) the driver doesn't
> hibernate/resume well, (2) there is some bad memory leak which causes
> your system to run out of memory.
> 
> You did not mention issue (1) - that you were hibernating and resuming
> (and expecting it to work, which it does not). For the latter, you
> probably need to track down where the memory is leaking in the driver,
> which is probably easier than tracking down the hibernate/resume
> issue.
> 
Sorry I thought that hibernation/resume was supported.

> Good luck with tracking down the memory leak. (you do understand that
> staging drivers are DIY - i.e. you try it only if you are willing to
> look into fixing it yourself - I hope )
> 
I wish I were that good, but I'll try.

Best regards,
- --
  Daniele

> On Wed, Mar 3, 2010 at 8:41 AM, Daniele C.
> <legolas558@users.sourceforge.net> wrote:
> Hello,
> 
> I am experiencing the documented crash after intense usage of the wi-fi device.
> 
> Best regards,
>>

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJLj4e2AAoJEON28As9epPA/+4H/jDpF8Y8FIzJ9UlDOD4yuVNb
yeRgoJW4h1fnL5atZ66Ku+5EehOsKYQEjQDa3Apwl+g1RXFPenbIm4+A/mJQ4INu
7/wIgQIGRh9mPLmRw1+ylMExBbGSm/v4yp4oUj1ZygLGbiBgV2iQMxbmYPQoCdNt
Rf6lvj20Sz0cfVZWvAw+9HfpMRHYYzQ2UgJkdl4iMaJyNIHhAHCgtMsC/00SGsCn
Wi9iQDtw4O5BbhGPx99J4OipBg0LfAihsOdzgxfv8/jNB9z6OwS4hudmwyHc4PHF
B+ZyEnEJfD3CL8qyaknHZXC18QV0NfnrM1P0NBU/E+WTlFuooywBOG+EWDRmF9E=
=NLMu
-----END PGP SIGNATURE-----

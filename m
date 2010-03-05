Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from m-04.th.seeweb.it ([217.64.195.227]:39302 "EHLO
	m-04.th.seeweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755485Ab0CEUOO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Mar 2010 15:14:14 -0500
Message-ID: <4B9165FE.1080502@users.sourceforge.net>
Date: Fri, 05 Mar 2010 21:13:50 +0100
From: "Daniele C." <legolas558@users.sourceforge.net>
MIME-Version: 1.0
To: Ivo van Doorn <ivdoorn@gmail.com>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
	Hin-Tak Leung <hintak.leung@gmail.com>,
	users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Subject: Re: rt2870 (staging kernel driver) crashes fatally
References: <4B8E20CF.50109@users.sourceforge.net> <3ace41891003031814r73d3b615x99d29e9cad1fd9c4@mail.gmail.com> <4B8F1C7F.7050305@lwfinger.net> <201003051722.42437.IvDoorn@gmail.com>
In-Reply-To: <201003051722.42437.IvDoorn@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

- -------- Original Message  --------
Subject: Re: rt2870 (staging kernel driver) crashes fatally
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Date: Fri Mar 05 2010 17:22:41 GMT+0100 (CET)

> On Thursday 04 March 2010, Larry Finger wrote:
>> On 03/03/2010 08:14 PM, Hin-Tak Leung wrote:
>>> You appear to have two issues - (1) the driver doesn't
>>> hibernate/resume well, (2) there is some bad memory leak which causes
>>> your system to run out of memory.
>>>
>>> You did not mention issue (1) - that you were hibernating and resuming
>>> (and expecting it to work, which it does not). For the latter, you
>>> probably need to track down where the memory is leaking in the driver,
>>> which is probably easier than tracking down the hibernate/resume
>>> issue.
>>>
>>> Good luck with tracking down the memory leak. (you do understand that
>>> staging drivers are DIY - i.e. you try it only if you are willing to
>>> look into fixing it yourself - I hope )
>>
>> By generating your own kernel with MEMLEAK enabled, you should be able to see
>> which data blob is being leaked. If you post that info, someone on this list
>> should be able to help you find the cause.
> 
> Actually the rt2x00-users list is not intended for the Ralink staging drivers.
> You have to use the staging mailing list: devel@driverdev.osuosl.org
> 
Yes, they refused my message but didn't tell anything about the staging mailing list which I couldn't find either and I am now reading from you. Many thanks for pointing this out.

I am now running with MEMLEAK enabled, as soon as I will make a new "hammering session" I'll grab the debug data and post another message.

Best regards,
- --
  Daniele

> Ivo
> 

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJLkWX+AAoJEON28As9epPAI9AH/j6nspsStdgsO4AigPVlQRrb
tc7VOTmv+EwuydntCERrlFGx20sNYfKcBtyt7WHg3TWQnMr7ISgCK4fB+YDvWExb
gS4+4n7u6AgDMPkrL3tr4PBvCFQJksGPh8epaB9InRv8JnBTmhwv287Ng7PiXY6h
P0YYmcxIgQ2F9BPA5PHJ3+Y2PqIQl+2cur95rp3Q7EUESwyHSeDqQnC1l9k50FsM
M6tGyTMBYUZDHEncdu6wpDipfnTQ9gUD0j4XUlfmRhVmedJ4DTknySMOup1dgNPz
Y1UMYhyvjkibeAEcep2KAShMwEfapyUf01gaGMsRxecvexQwC1YsekGJ1/pbCBs=
=6LbC
-----END PGP SIGNATURE-----

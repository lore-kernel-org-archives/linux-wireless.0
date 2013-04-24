Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:48291 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932196Ab3DXXIR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Apr 2013 19:08:17 -0400
Received: by mail-la0-f44.google.com with SMTP id ed20so2091513lab.3
        for <linux-wireless@vger.kernel.org>; Wed, 24 Apr 2013 16:08:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51786303.3070107@lwfinger.net>
References: <CALvqYaTZrtSsP9GQzH4B988KjPg+LRCcyREKZ1zkjoaEDKPHNA@mail.gmail.com>
	<CALvqYaTSYR43rS-pptFKCfsgvsatrUSz4v+AFBPQ0UrHC4WkXA@mail.gmail.com>
	<5177F100.1070803@lwfinger.net>
	<CALvqYaQt+nL-PxSeEUNpsG9SWV+--S64ksr1UR+8TPg5dVPKXA@mail.gmail.com>
	<51780C92.4000208@lwfinger.net>
	<CALvqYaRrjMtPE72PGR-Zzuj11CL=E6+ruC+E1wGPO3m5wgdOhg@mail.gmail.com>
	<CALvqYaT==e4U43dxtyX55A9CNgWh9apHMrj89=bBybutyJOoiw@mail.gmail.com>
	<51781976.3000601@lwfinger.net>
	<CALvqYaQTQ5=ER=F1-bxnJQKkFjrg6UH+1JWLexUPVZ3cFBG5UQ@mail.gmail.com>
	<51786303.3070107@lwfinger.net>
Date: Thu, 25 Apr 2013 01:08:15 +0200
Message-ID: <CALvqYaQ_z7w6yLeNb=Q7Sm=Et3Rxj+TP6vi=KcyhDpT4AmY4kA@mail.gmail.com> (sfid-20130425_011840_428054_4D5B4151)
Subject: Re: Fwd: Realtek 8192CU not working
From: Michael Stahn <michael.stahn.42@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This kind of error doesn't seem to show up on the USB 2.0 interface. I
just configured the AP for WPA+TKIP but no change. Now the Adapter
won't connect anymore even I reload the module..pretty random error.
I'll try some other ideas in the next days...

2013/4/25 Larry Finger <Larry.Finger@lwfinger.net>:
> On 04/24/2013 05:24 PM, Michael Stahn wrote:
>>
>> I'm using WPA/PSK, attached is the whole kernel dump.
>>
>
> I don't see the "ehci_hcd 0000:00:16.2: detected XactErr len 0/15360 retry
> 1" problem in this dump.
>
> If you are just having trouble connecting, there is an unknown problem. The
> driver can connect with WPA2, but not WPA.
>
> Larry
>
>

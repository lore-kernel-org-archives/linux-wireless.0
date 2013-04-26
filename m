Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:48281 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097Ab3DZKmb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Apr 2013 06:42:31 -0400
Received: by mail-la0-f47.google.com with SMTP id em20so199624lab.6
        for <linux-wireless@vger.kernel.org>; Fri, 26 Apr 2013 03:42:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5179B785.7050704@lwfinger.net>
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
	<CALvqYaQ_z7w6yLeNb=Q7Sm=Et3Rxj+TP6vi=KcyhDpT4AmY4kA@mail.gmail.com>
	<5179B785.7050704@lwfinger.net>
Date: Fri, 26 Apr 2013 12:42:29 +0200
Message-ID: <CALvqYaRfK2M+mruRcoQ=QWr-720Zj-1vgsQePCH2YQ6tfXV38A@mail.gmail.com> (sfid-20130426_124241_254762_AED4A39C)
Subject: Re: Fwd: Realtek 8192CU not working
From: Michael Stahn <michael.stahn.42@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

thx, I'll try it out in the next days.

2013/4/26 Larry Finger <Larry.Finger@lwfinger.net>:
> On 04/24/2013 06:08 PM, Michael Stahn wrote:
>>
>> This kind of error doesn't seem to show up on the USB 2.0 interface. I
>> just configured the AP for WPA+TKIP but no change. Now the Adapter
>> won't connect anymore even I reload the module..pretty random error.
>> I'll try some other ideas in the next days...
>
>
> I found some problems today. With the attached patched, my device connects
> to WEP, WPA and WPA2 networks.
>
> Larry
>
>

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ia0-f171.google.com ([209.85.210.171]:63766 "EHLO
	mail-ia0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757971Ab3DXXSa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Apr 2013 19:18:30 -0400
Received: by mail-ia0-f171.google.com with SMTP id r13so2043503iar.2
        for <linux-wireless@vger.kernel.org>; Wed, 24 Apr 2013 16:18:29 -0700 (PDT)
Message-ID: <51786840.3090907@lwfinger.net> (sfid-20130425_011841_404397_E5DE3D64)
Date: Wed, 24 Apr 2013 18:18:24 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Stahn <michael.stahn.42@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Fwd: Realtek 8192CU not working
References: <CALvqYaTZrtSsP9GQzH4B988KjPg+LRCcyREKZ1zkjoaEDKPHNA@mail.gmail.com> <CALvqYaTSYR43rS-pptFKCfsgvsatrUSz4v+AFBPQ0UrHC4WkXA@mail.gmail.com> <5177F100.1070803@lwfinger.net> <CALvqYaQt+nL-PxSeEUNpsG9SWV+--S64ksr1UR+8TPg5dVPKXA@mail.gmail.com> <51780C92.4000208@lwfinger.net> <CALvqYaRrjMtPE72PGR-Zzuj11CL=E6+ruC+E1wGPO3m5wgdOhg@mail.gmail.com> <CALvqYaT==e4U43dxtyX55A9CNgWh9apHMrj89=bBybutyJOoiw@mail.gmail.com> <51781976.3000601@lwfinger.net> <CALvqYaQTQ5=ER=F1-bxnJQKkFjrg6UH+1JWLexUPVZ3cFBG5UQ@mail.gmail.com> <51786303.3070107@lwfinger.net> <CALvqYaQ_z7w6yLeNb=Q7Sm=Et3Rxj+TP6vi=KcyhDpT4AmY4kA@mail.gmail.com>
In-Reply-To: <CALvqYaQ_z7w6yLeNb=Q7Sm=Et3Rxj+TP6vi=KcyhDpT4AmY4kA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/24/2013 06:08 PM, Michael Stahn wrote:
> This kind of error doesn't seem to show up on the USB 2.0 interface. I
> just configured the AP for WPA+TKIP but no change. Now the Adapter
> won't connect anymore even I reload the module..pretty random error.
> I'll try some other ideas in the next days...

OK, the USB3.0 error is a different matter. You should report that on the USB 
mailing list.

You need WPA2-AES/CCMP encryption for it to work. I'm looking into that problem now.

Larry



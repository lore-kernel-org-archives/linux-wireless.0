Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f176.google.com ([209.85.223.176]:34812 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756188Ab3DXRmQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Apr 2013 13:42:16 -0400
Received: by mail-ie0-f176.google.com with SMTP id x14so2444571ief.35
        for <linux-wireless@vger.kernel.org>; Wed, 24 Apr 2013 10:42:16 -0700 (PDT)
Message-ID: <51781976.3000601@lwfinger.net> (sfid-20130424_194220_004700_E191DE3F)
Date: Wed, 24 Apr 2013 12:42:14 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Stahn <michael.stahn.42@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Fwd: Realtek 8192CU not working
References: <CALvqYaTZrtSsP9GQzH4B988KjPg+LRCcyREKZ1zkjoaEDKPHNA@mail.gmail.com> <CALvqYaTSYR43rS-pptFKCfsgvsatrUSz4v+AFBPQ0UrHC4WkXA@mail.gmail.com> <5177F100.1070803@lwfinger.net> <CALvqYaQt+nL-PxSeEUNpsG9SWV+--S64ksr1UR+8TPg5dVPKXA@mail.gmail.com> <51780C92.4000208@lwfinger.net> <CALvqYaRrjMtPE72PGR-Zzuj11CL=E6+ruC+E1wGPO3m5wgdOhg@mail.gmail.com> <CALvqYaT==e4U43dxtyX55A9CNgWh9apHMrj89=bBybutyJOoiw@mail.gmail.com>
In-Reply-To: <CALvqYaT==e4U43dxtyX55A9CNgWh9apHMrj89=bBybutyJOoiw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/24/2013 12:27 PM, Michael Stahn wrote:
> okay now it gets a little awkward: un/reloading the driver seems to
> fix the authentication-problem (ip gets assigned), but no ping
> succeeds..
> http://bpaste.net/show/93913/
>
> 2013/4/24 Michael Stahn <michael.stahn.42@gmail.com>:
>> I'm using a i686 Architecture on AMD E2-1800 APU with Radeon(tm) HD
>> Graphics AuthenticAMD GNU/Linux with linux 3.7.10. CONFIG_USB_DEBUG
>> was allready set. I've used an USB 3.0 port previously and now
>> rechecked everything with a USB2.0 port. The result is nearly the
>> same: first connection succeeds (ping response), doing a manual
>> reconnect to the AP leads to the same error. I've done several
>> ifconfig down/ups at the end with no change.
>> dmesg gives: http://bpaste.net/show/93912/

To be able to work on the error messages from ehci-hcd, it is likely that we 
will need all the messages associated with the initialization of the hub. That 
is the reason that I asked that you post the entire dmesg output, starting at 
time 0.

What encryption are you using?

Larry



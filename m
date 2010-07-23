Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36594 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753623Ab0GWXTy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jul 2010 19:19:54 -0400
Received: by fxm14 with SMTP id 14so5282692fxm.19
        for <linux-wireless@vger.kernel.org>; Fri, 23 Jul 2010 16:19:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1279816465.1630.9.camel@powerslave>
References: <4C37BCA0.5090607@deltatee.com>
	<AC090B9732AB2B4DB7FF476E907FE660010685F34E@dnce02.ent.ti.com>
	<AANLkTilHNKeRZX5CMplyriTo2hTPBrz_z1_Zpwoy3SZx@mail.gmail.com>
	<AC090B9732AB2B4DB7FF476E907FE66001069662F2@dnce02.ent.ti.com>
	<AC090B9732AB2B4DB7FF476E907FE6600106966BA5@dnce02.ent.ti.com>
	<4C45ED36.2090604@deltatee.com>
	<AANLkTinjvF9UeV7d2aBUy6HfexuAeL_cdsVPGVxSRVMp@mail.gmail.com>
	<AANLkTinnYeJPV-xxg7DdPXnWW_kD7X1TVcd9HrhupJWS@mail.gmail.com>
	<1279780848.2322.31.camel@powerslave>
	<AANLkTilZhvGg2SUk5btpQQA3qj2k4rob4rTychDu7gXM@mail.gmail.com>
	<1279816465.1630.9.camel@powerslave>
Date: Sat, 24 Jul 2010 01:19:53 +0200
Message-ID: <AANLkTikHUe3qcon_sgnSpoNY=d5OVS9oBPLioNp0F5Kn@mail.gmail.com>
Subject: Re: wl1271 firmware
From: Pazzo Da Legare <pazzodalegare@gmail.com>
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Levi, Shahar" <shahar_levi@ti.com>,
	Logan Gunthorpe <logang@deltatee.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear Luciano,

Obviously you are right: I did a stupid error (I modified wrong
wl1271.h file, the one for and older compact-wireless...), sorry for
that.

I attached what I got. Note that I have a limited buffer for system
log so this is the last part only, I hope is enough.

http://pastebin.com/7nLJeXkb

Thank you again,

pz

2010/7/22 Luciano Coelho <luciano.coelho@nokia.com>:
> On Thu, 2010-07-22 at 17:41 +0200, ext Pazzo Da Legare wrote:
>> I enabled the DEBUG_LEVEL as you advice me but I have no additional
>> information....
>>
>> [  186.230000] wl1271_sdio mmc0:0001:2: firmware: requesting
>> wl1271-fw.bin
>> [  186.420000] wl1271_sdio mmc0:0001:2: firmware: requesting
>> wl1271-nvs.bin
>> [  186.860000] wl1271: firmware booted (Rev 6.1.0.0.310)
>> [  186.880000] ADDRCONF(NETDEV_UP): wlan0: link is not ready
>> [  187.380000] wl1271: ERROR ELP wakeup timeout!
>> [  187.880000] wl1271: ERROR ELP wakeup timeout!
>
> There's something wrong.  There should have been a lot more traces with
> the DEBUG_LEVEL I proposed.  Please try again.
>
>
> --
> Cheers,
> Luca.
>
>

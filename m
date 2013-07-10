Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lmv.inov.pt ([146.193.64.2]:51066 "EHLO lmv.inov.pt"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753981Ab3GJMes (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jul 2013 08:34:48 -0400
Message-ID: <51DD54D4.6090502@inov.pt> (sfid-20130710_143452_018740_F5831907)
Date: Wed, 10 Jul 2013 13:34:28 +0100
From: =?UTF-8?B?Sm9zw6kgTWlndWVsIEdvbsOnYWx2ZXM=?=
	<jose.goncalves@inov.pt>
MIME-Version: 1.0
To: Luciano Coelho <coelho@ti.com>
CC: Arik Nemtsov <arik@wizery.com>, linux-wireless@vger.kernel.org
Subject: Re: wl127x: Unable to associate with a WPA2-PSK AP
References: <51DB0ACC.7050800@inov.pt>  <CA+XVXfcakDiN1pPqGDQAN=VR8p_C1LUWGt_nX-rGXDLsBkk+Dw@mail.gmail.com>  <51DB4195.8090103@inov.pt>  <CA+XVXffKKVMeD5GXkzDsnvR7=Ocb8QP0Y7eeD-ZZTzsxJL7PqA@mail.gmail.com>  <1373360959.21065.183.camel@cumari.coelho.fi> <51DBD904.6020007@inov.pt>  <1373362817.21065.191.camel@cumari.coelho.fi> <51DBF389.5060209@inov.pt>  <CA+XVXfeB3jpXaaV4vgbHUVRdPeH9tPVRWvRhZsYHmg33HNzmmw@mail.gmail.com>  <51DC0E7C.9080306@inov.pt>  <CA+XVXfd8WouC7UWwD5z=OAMT2AUaU25d13thinjRDe-JpTQCEw@mail.gmail.com>  <51DCA3EF.8090900@inov.pt> <1373448177.8385.22.camel@cumari.coelho.fi>
In-Reply-To: <1373448177.8385.22.camel@cumari.coelho.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10-07-2013 10:22, Luciano Coelho wrote:
>> Can my problems be related with an inadequate NVS file? I've generated
>> it with the calibrate tool from ti-utils and the INI file TQS_D_1.7.ini
>> with the command "calibrator plt calibrate". Is this the correct INI for
>> my module (Jorjin's WG7350 - wl1273 based)?
> Yes, the problem can be because of a bad NVS file.  Try with the
> "default" NVS file that is provided in linux-firmware.git.  That one
> won't be optimal, but should work okay.

I have the same problems with the default NVS file.

>
> I'm not sure which FEM Jorjin's module use.  Can you ask them?

I will ask my contact.

>
> I found this on github (Dick Chiang appears to work for Jorjin):
> https://github.com/dickychiang/compat-wireless-r5/blob/master/jorjin/ini_files/TQS_D_1.7_WG7350_NLCP.ini
>
> DISCLAIMER: I have no clue whether this is the correct INI file or not
> and I'm not claiming it's associated with TI in any way, so use it at
> your own risk.
>

Same problem after generating a new NVS file from this INI.

I will try a new AP to see how it behaves...

José Gonçalves

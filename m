Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lmv.inov.pt ([146.193.64.2]:38444 "EHLO lmv.inov.pt"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756435Ab3GKS0o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jul 2013 14:26:44 -0400
Message-ID: <51DEF8D0.10000@inov.pt> (sfid-20130711_202647_113445_A6C92602)
Date: Thu, 11 Jul 2013 19:26:24 +0100
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
> I'm not sure which FEM Jorjin's module use.  Can you ask them?
>
> I found this on github (Dick Chiang appears to work for Jorjin):
> https://github.com/dickychiang/compat-wireless-r5/blob/master/jorjin/ini_files/TQS_D_1.7_WG7350_NLCP.ini
>
> DISCLAIMER: I have no clue whether this is the correct INI file or not
> and I'm not claiming it's associated with TI in any way, so use it at
> your own risk.
>

Just for the record, I got the information from my contact that the indicated INI 
file is the proper one for Jorjin's WG7350 module.

José Gonçalves

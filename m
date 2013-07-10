Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lmv.inov.pt ([146.193.64.2]:43689 "EHLO lmv.inov.pt"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754402Ab3GJQap (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jul 2013 12:30:45 -0400
Message-ID: <51DD8C20.7010900@inov.pt> (sfid-20130710_183049_501882_B9F7D5A1)
Date: Wed, 10 Jul 2013 17:30:24 +0100
From: =?UTF-8?B?Sm9zw6kgTWlndWVsIEdvbsOnYWx2ZXM=?=
	<jose.goncalves@inov.pt>
MIME-Version: 1.0
To: Luciano Coelho <coelho@ti.com>
CC: Arik Nemtsov <arik@wizery.com>, linux-wireless@vger.kernel.org
Subject: Re: wl127x: Unable to associate with a WPA2-PSK AP
References: <51DB0ACC.7050800@inov.pt>  <CA+XVXfcakDiN1pPqGDQAN=VR8p_C1LUWGt_nX-rGXDLsBkk+Dw@mail.gmail.com>  <51DB4195.8090103@inov.pt>  <CA+XVXffKKVMeD5GXkzDsnvR7=Ocb8QP0Y7eeD-ZZTzsxJL7PqA@mail.gmail.com>  <1373360959.21065.183.camel@cumari.coelho.fi> <51DBD904.6020007@inov.pt>  <1373362817.21065.191.camel@cumari.coelho.fi> <51DBF389.5060209@inov.pt>  <CA+XVXfeB3jpXaaV4vgbHUVRdPeH9tPVRWvRhZsYHmg33HNzmmw@mail.gmail.com>  <51DC0E7C.9080306@inov.pt>  <CA+XVXfd8WouC7UWwD5z=OAMT2AUaU25d13thinjRDe-JpTQCEw@mail.gmail.com>  <51DCA3EF.8090900@inov.pt> <1373448177.8385.22.camel@cumari.coelho.fi> <51DD54D4.6090502@inov.pt>
In-Reply-To: <51DD54D4.6090502@inov.pt>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10-07-2013 13:34, José Miguel Gonçalves wrote:
>
> I will try a new AP to see how it behaves...
>

I've tested with my Android smartphone acting as an AP, without authentication, 
and I'm also unable to associate!

I get from iw the following error message:

wlan0 (phy #0): failed to connect to b4:07:f9:49:cc:65, status: 1: Unspecified failure

Complete log is here:

http://pastebin.com/DzPmMw8i

So, something is definitely wrong with my setup... but what?
Hope that log has some useful info for you...

Best regards,
José Gonçalves

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lmv.inov.pt ([146.193.64.2]:37360 "EHLO lmv.inov.pt"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754518Ab3GKMJW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jul 2013 08:09:22 -0400
Message-ID: <51DEA05A.5020401@inov.pt> (sfid-20130711_140926_124361_30CAC12F)
Date: Thu, 11 Jul 2013 13:08:58 +0100
From: =?UTF-8?B?Sm9zw6kgTWlndWVsIEdvbsOnYWx2ZXM=?=
	<jose.goncalves@inov.pt>
MIME-Version: 1.0
To: Luciano Coelho <coelho@ti.com>
CC: Arik Nemtsov <arik@wizery.com>, linux-wireless@vger.kernel.org
Subject: Re: wl127x: Unable to associate with a WPA2-PSK AP
References: <51DB0ACC.7050800@inov.pt>    <CA+XVXfcakDiN1pPqGDQAN=VR8p_C1LUWGt_nX-rGXDLsBkk+Dw@mail.gmail.com>    <51DB4195.8090103@inov.pt>    <CA+XVXffKKVMeD5GXkzDsnvR7=Ocb8QP0Y7eeD-ZZTzsxJL7PqA@mail.gmail.com>    <1373360959.21065.183.camel@cumari.coelho.fi> <51DBD904.6020007@inov.pt>    <1373362817.21065.191.camel@cumari.coelho.fi> <51DBF389.5060209@inov.pt>    <CA+XVXfeB3jpXaaV4vgbHUVRdPeH9tPVRWvRhZsYHmg33HNzmmw@mail.gmail.com>    <51DC0E7C.9080306@inov.pt>    <CA+XVXfd8WouC7UWwD5z=OAMT2AUaU25d13thinjRDe-JpTQCEw@mail.gmail.com>    <51DCA3EF.8090900@inov.pt> <1373448177.8385.22.camel@cumari.coelho.fi>   <51DD54D4.6090502@inov.pt> <51DD8C20.7010900@inov.pt>  <1373476663.8385.28.camel@cumari.coelho.fi> <51DD9E6C.5060008@inov.pt> <1373488063.8385.31.camel@cumari.coelho.fi>
In-Reply-To: <1373488063.8385.31.camel@cumari.coelho.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luca,

On 10-07-2013 21:27, Luciano Coelho wrote:
> I have a text console only system. I could put tcpdump on my system, but I think I
> can not monitor wireless traffic with it, or can I?
> tcpdump will probably not be enough.  But since this stuff is *wireless*
> you can sniff from a different PC.  If you have Linux PC, just plug in
> your TP-Link dongle in it, launch wireshark and you should be able to
> sniff (unencrypted) connections between other devices easily.
>

I've setup my Linuc PC as a sniffer and yes I see a lot of of authentication 
frames on the air when I try to associate with my open AP (Android phone).

I've repeated the process with a TP-Link dongle and I see a clean 802.11 
association sequence.

What I found strange is that I don't see "probe request" frames on the wl12xx 
captured frames, it starts directly with an "authentication" frame, when with the 
TP-Link dongle (ath9k_htc driver) the first frame sent by is a "probe request"!

I can provide the Wirehsark capture files. What is the best way to send them 
through the mailing list?

Best regards,
José Gonçalves

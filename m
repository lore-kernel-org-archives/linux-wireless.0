Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lmv.inov.pt ([146.193.64.2]:43598 "EHLO lmv.inov.pt"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932153Ab3GKNeH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jul 2013 09:34:07 -0400
Message-ID: <51DEB436.9000300@inov.pt> (sfid-20130711_153436_446230_F55EB86B)
Date: Thu, 11 Jul 2013 14:33:42 +0100
From: =?UTF-8?B?Sm9zw6kgTWlndWVsIEdvbsOnYWx2ZXM=?=
	<jose.goncalves@inov.pt>
MIME-Version: 1.0
To: Luciano Coelho <coelho@ti.com>
CC: Arik Nemtsov <arik@wizery.com>, linux-wireless@vger.kernel.org
Subject: Re: wl127x: Unable to associate with a WPA2-PSK AP
References: <51DB0ACC.7050800@inov.pt>     <CA+XVXfcakDiN1pPqGDQAN=VR8p_C1LUWGt_nX-rGXDLsBkk+Dw@mail.gmail.com>     <51DB4195.8090103@inov.pt>     <CA+XVXffKKVMeD5GXkzDsnvR7=Ocb8QP0Y7eeD-ZZTzsxJL7PqA@mail.gmail.com>     <1373360959.21065.183.camel@cumari.coelho.fi> <51DBD904.6020007@inov.pt>     <1373362817.21065.191.camel@cumari.coelho.fi> <51DBF389.5060209@inov.pt>     <CA+XVXfeB3jpXaaV4vgbHUVRdPeH9tPVRWvRhZsYHmg33HNzmmw@mail.gmail.com>     <51DC0E7C.9080306@inov.pt>     <CA+XVXfd8WouC7UWwD5z=OAMT2AUaU25d13thinjRDe-JpTQCEw@mail.gmail.com>     <51DCA3EF.8090900@inov.pt> <1373448177.8385.22.camel@cumari.coelho.fi>    <51DD54D4.6090502@inov.pt> <51DD8C20.7010900@inov.pt>   <1373476663.8385.28.camel@cumari.coelho.fi> <51DD9E6C.5060008@inov.pt>  <1373488063.8385.31.camel@cumari.coelho.fi> <51DEA05A.5020401@inov.pt> <1373549359.8385.36.camel@cumari.coelho.fi>
In-Reply-To: <1373549359.8385.36.camel@cumari.coelho.fi>
Content-Type: multipart/mixed;
 boundary="------------040305090504060605050905"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040305090504060605050905
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11-07-2013 14:29, Luciano Coelho wrote:
> On Thu, 2013-07-11 at 13:08 +0100, José Miguel Gonçalves wrote:
>>
>> I've setup my Linuc PC as a sniffer and yes I see a lot of of authentication
>> frames on the air when I try to associate with my open AP (Android phone).
>>
>> I've repeated the process with a TP-Link dongle and I see a clean 802.11
>> association sequence.
>>
>> What I found strange is that I don't see "probe request" frames on the wl12xx
>> captured frames, it starts directly with an "authentication" frame, when with the
>> TP-Link dongle (ath9k_htc driver) the first frame sent by is a "probe request"!
> Usually the connection will start with a probe request, but if there is
> a response in the cache, we may skip it.  In any case, this is probably
> happening because your sniffer is missing those frames (which again
> points to problems with RF).
>
>
>> I can provide the Wirehsark capture files. What is the best way to send them
>> through the mailing list?
> Cut only the portion that matters, so the file is small and gzip it.
> Small files can be sent as attachments to the list.
>

Here they go...

José Gonçalves

--------------040305090504060605050905
Content-Type: application/x-gzip;
 name="ath9k_htc.pcap.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="ath9k_htc.pcap.gz"

H4sICL6z3lEAA2F0aDlrX2h0Yy5wY2FwALtyeNNCJgYWBhj4/5+BoR5Ia026F+j3kYMhCchO
AstIMeh7MDAsnHZZHcQTYMrhXMCwEchyAOsCgQ0eVRP+l0DYBiwMnI55KUX5mSmOAYwMzIxs
ulJ5gtL/GRCAEcHMVWZ9BLKxzJaToRDIL0Sy8f8jZBvXAlkBDFaMELu2sP/0PJMKIT9wPLk4
B6wvhYERxXaOppbuaSoGHjlAV2gxMugzMhix8AhJJNzlZBCQYAJrUf2daaANdMAvVVYGDSBf
A8kBV3rvITlgPZB1BYghDnj+/ckvkD4PPVYGd6CoO5K+M1OR9a0D6cHq8AOcDAwgVyA5Z/3i
rPMgY7n6WBlCgfxQJGMLviIbuwkaghCjkA0PYFFkAQYxcjgwsXCLAT2uYsRi4JGQU5Z7zwJk
Sc4kVoZwoBHhyG7/eQ8tmgWwuv0CJzCoGRgPIMIYI2j7op1tTYHW2HewMlgA+RZI1vi2lWsg
rNkAZB3A6hcGBmaGp8//CYDM2dSJGUW97ejmoEYRAPDHiirmAgAA
--------------040305090504060605050905
Content-Type: application/x-gzip;
 name="wl12xx.pcap.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="wl12xx.pcap.gz"

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
--------------040305090504060605050905--

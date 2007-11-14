Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from post.fh-kl.de ([143.93.17.200]:57508 "EHLO post.fh-kl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752329AbXKNJZE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2007 04:25:04 -0500
Received: from localhost (localhost [127.0.0.1])
	by post.fh-kl.de (Postfix) with ESMTP id A5A2F24005C1
	for <linux-wireless@vger.kernel.org>; Wed, 14 Nov 2007 10:25:01 +0100 (CET)
Received: from post.fh-kl.de ([127.0.0.1])
	by localhost (post.fh-kl.de [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id qnTCMXj32eTu for <linux-wireless@vger.kernel.org>;
	Wed, 14 Nov 2007 10:24:56 +0100 (CET)
Received: from [10.0.23.230] (aoip1.informatik.fh-kl.de [143.93.17.33])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by post.fh-kl.de (Postfix) with ESMTP id BE1982417BB9
	for <linux-wireless@vger.kernel.org>; Wed, 14 Nov 2007 10:24:51 +0100 (CET)
Message-ID: <473ABEE3.1000104@fh-kl.de> (sfid-20071114_092510_061986_1D54B31C)
Date: Wed, 14 Nov 2007 10:24:51 +0100
From: Patrick Ziegler <patrick.ziegler@fh-kl.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: Wimax
References: <47398FD8.6030409@fh-kl.de> <1194967777.2955.31.camel@localhost.localdomain>
In-Reply-To: <1194967777.2955.31.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Williams schrieb:
> On Tue, 2007-11-13 at 12:51 +0100, Patrick Ziegler wrote:
>   
>> Hi,
>>
>> is there any support for Wimax network cards in the kernel yet ?
>>     
>
> No, unless those cards work like broadband cellular cards and just
> present a USB serial interface to the kernel.  I haven't been able to
> get a hold of WiMAX parts yet (preferably 802.16e-2005 mobile wimax
> parts like the Airspan MiMAX USB) not that I've tried extremely hard.
>   
I don't believe that the cards act like a broadband cellular cards. I 
had a Wimax PCMCIA card for a short time in my Hand and it didn't act as 
a serial device. In the near future I will get a Wimax ExpressCard 
(Zyxel MAX-706) with which I can make more and intensive tests.
>   
>> is this the right mailing list for this topic ?
>>     
>
> Probably for now, yes.
>
>   
>> is someone working on a Wimax integration ?
>>     
>
> I've been thinking about WiMAX for quite a while, but only recently have
> real cards started to appear.  My fear is that with WiMAX, Linux will be
> where it was with 802.11 3 years ago.  No hardware support, no vendor
> support, nothing.
>
> The problem with WiMAX is that many operators have _licensed_ spectrum
> for WiMAX.  The software stack is more complicated, and vendors may put
> more and more software on the host rather than in firmware.  However,
> since software stack will deal with things like QoS in licensed spectrum
> and whatnot, vendors may close the stack and do things like binary blobs
> linked to the kernel module, or things like the old IPW regulatory
> daemon.  Not sure how to avoid that.
>   
Oh this vision sounds not good.

Patrick


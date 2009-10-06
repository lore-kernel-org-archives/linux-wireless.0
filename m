Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:43639 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757875AbZJFTAK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Oct 2009 15:00:10 -0400
Message-ID: <4ACB9375.6050805@gmx.de>
Date: Tue, 06 Oct 2009 20:59:01 +0200
From: Joerg Albert <jal2@gmx.de>
MIME-Version: 1.0
To: Ahmed A <ahmedcali@yahoo.com>
CC: David Acker <dacker@roinet.com>, linux-wireless@vger.kernel.org
Subject: Re: Linux wifi development board
References: <175271.7461.qm@web32506.mail.mud.yahoo.com> <4ACB42CB.7010403@roinet.com>
In-Reply-To: <4ACB42CB.7010403@roinet.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/06/2009 03:14 PM, David Acker wrote:
> Ahmed A wrote:
>> Hello,
>>
>> I have been looking online for a Linux wifi development board.  I have
>> come across a few from small companies (reasonably priced), but most
>> of those companies seem to be out of business.  I would appreciate
>> suggestions from anyone that may have used one recently, or suggest a
>> link where I can more info some popular ones.
>>
>> I am mostly interested in doing some software development, prototyping
>> on the "application processor", not on the "baseband processor" (radio
>> part).
>>
>> If there is an alternate mailing list I can post my question, I would
>> appreciate that also.
> 
> I have had good luck with boards from Gateworks,
> http://www.gateworks.com/ and radios from Ubiquiti, http://ubnt.com/ .
> All of it is supported by OpenWRT, although I believe that the gw2348-4
> (avila) has mainline support.

If Avila boards are a bit to pricey, you may consider getting an Ubiquity Routerstation (Pro) instead.
It ships with OpenWrt.
Anyhow, just check which devices have OpenWRT mainline support (http://www.openwrt.org) and choose one of them.

If you prefer x86 hardware and more standard distributions you may consider an Alix board
(http://www.pcengines.ch/alix.htm). I've got one here running Debian Lenny on a 8 GByte CompactFlash card.

Both Routerstation and Alix require additional miniPCI (or USB) WLAN cards.

Regards,
Joerg.

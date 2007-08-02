Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:52241 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758881AbXHBQaP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2007 12:30:15 -0400
Message-ID: <46B20695.2080100@lwfinger.net>
Date: Thu, 02 Aug 2007 11:30:13 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [RFC 0/10] Port of bcm43xx from softmac to mac80211
References: <46b1fde0.b+weBDN75J0SPe2a%Larry.Finger@lwfinger.net> <200708021807.20649.mb@bu3sch.de>
In-Reply-To: <200708021807.20649.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> On Thursday 02 August 2007, Larry Finger wrote:
>> Driver bcm43xx is being ported from using SoftMAC to mac80211. For rewiew,
>> this series of patches is being prepared; however, the final patch will be
>> a single entity so that compilation during bisection will not break.
>>
>> The contents of the various pieces are as follows:
>>
>>  1. Kconfig, Makefile and the main header file.
>>  2. bcm43xx_debugfs.c and bcm43xx_debugfs.h
>>  3. bcm43xx_dma.c and bcm43xx_dma.h
>>  4. bcm43xx_ilt.c, bcm43xx_ilt.h, bcm43xx_leds.c and bcm43xx_leds.h
>>  5. bcm43xx_main.c and bcm43xx_main.h
>>  6. bcm43xx_phy.c and bcm43xx_phy.h
>>  7. bcm43xx_pio.c and bcm43xx_pio.h
>>  8. bcm43xx_radio.c and bcm43xx_radio.h
>>  9. bcm43xx_sysfs.c and bcm43xx_sysfs.h
>> 10: bcm43xx_xmit.c and bcm43xx_xmit.h
>>
>> In general, this port consists of taking the files bcm43xx_phy and 
>> bcm43xx_radio from the softmac driver and converting them to work with
>> the files from the mac80211 version, which has been back-converted to 
>> use V3 firmware.
> 
> I don't really want to review 10 huge patches that replace
> X by Y. If the code works, fine. Go for it. You get my ACK, if it works
> on the hardware where it matters. ;)

I was hoping this would be your response, but I had to make the effort. I'll wait for a couple of 
days to see if anyone else has any comments and send it on to Linville and hope it ends up in -mm 
fairly soon. It _DOES_ work on the hardware.

Larry

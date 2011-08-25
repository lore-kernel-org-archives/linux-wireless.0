Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2116 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752365Ab1HYKiS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 06:38:18 -0400
Message-ID: <4E562608.9060700@broadcom.com> (sfid-20110825_123821_965563_140A2BBE)
Date: Thu, 25 Aug 2011 12:38:00 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Hao Han" <hhanwm@gmail.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: force wifi radio to sleep immediately
References: <CAGwCZhqDBZ4QGC_+3Bdbk=vRCnr0=sVdyR3J7WWqExf_hZQpLA@mail.gmail.com>
 <4E54C87A.4080407@broadcom.com>
 <CAGwCZhrYA2e_dVf6uHDaTfC35m2wopdLCOit8UFDa8D9v_v3Tw@mail.gmail.com>
In-Reply-To: <CAGwCZhrYA2e_dVf6uHDaTfC35m2wopdLCOit8UFDa8D9v_v3Tw@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/24/2011 12:12 PM, Hao Han wrote:
> Thank you for your quick reply, Gr. AvS.
>
> According to my understanding, in power save mode (PSM), the station
> will go to sleep immediately (i.e. maintaining a very low power) after
> sending packet with pwr mgt bit in 802.11 mac header setting to 1.
>
> My question is if we can force the station to go to such a low power
> level by calling some function.
>
> It seems to me that it costs extra time to disable/enable the radio,
> right? I hope to do it very quickly.
>
> I appreicate your help!
>
> Best,
> Hao

I see. Your question is really about power save, which involves more 
that the radio. Power save is a process better left to the device so 
there is no interface in place to force that upon a driver/device.

Gr. AvS

-- 
Almost nobody dances sober, unless they happen to be insane.
-- H.P. Lovecraft --



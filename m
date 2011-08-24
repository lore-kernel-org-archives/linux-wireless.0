Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2342 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752124Ab1HXJq5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 05:46:57 -0400
Message-ID: <4E54C87A.4080407@broadcom.com> (sfid-20110824_114700_631572_4776DB05)
Date: Wed, 24 Aug 2011 11:46:34 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Hao Han" <hhanwm@gmail.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: force wifi radio to sleep immediately
References: <CAGwCZhqDBZ4QGC_+3Bdbk=vRCnr0=sVdyR3J7WWqExf_hZQpLA@mail.gmail.com>
In-Reply-To: <CAGwCZhqDBZ4QGC_+3Bdbk=vRCnr0=sVdyR3J7WWqExf_hZQpLA@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/24/2011 10:43 AM, Hao Han wrote:
> Dear All,
>
> I am currently working on a research project based on BCM4329 driver
> on Nexus One. In the project, I am trying to control wifi radio to sleep
> and wake up manually (i.e without setting PM_OFF, PM_FAST, or PM_MAX mode). I
> have digged into the source code for a while, but till now I have no
> idea how to do that. If possible, could anyone please tell me if there is
> any function I can call to force wifi radio to sleep or wake up
> immediately.
>
> Any hint is appreciated. Thank you!
>
> Best,
> Hao
> --

Hi Hao,

Could please elaborate on what 'wifi radio' means in your description. 
It makes me think about RFKILL, but that may not be the thing you are 
looking for. With it you can disable/enable the radio within the 
wireless chipset. The terms sleep and wakeup feel a little odd when 
talking about radios.

Gr. AvS

-- 
Almost nobody dances sober, unless they happen to be insane.
-- H.P. Lovecraft --



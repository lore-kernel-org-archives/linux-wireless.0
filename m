Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f180.google.com ([209.85.220.180]:45549 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408Ab3F0PHx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jun 2013 11:07:53 -0400
Received: by mail-vc0-f180.google.com with SMTP id gf11so317092vcb.25
        for <linux-wireless@vger.kernel.org>; Thu, 27 Jun 2013 08:07:52 -0700 (PDT)
Message-ID: <51CC5541.8010003@lwfinger.net> (sfid-20130627_170756_854695_17E4B5D3)
Date: Thu, 27 Jun 2013 10:07:45 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
CC: "shiki.biomernok" <shiki.biomernok@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Fwd: Re: TP-Link 8200ND - rtl8192cu module not loading / working
References: <51A77433.2060702@lwfinger.net> <51CAD0B8.3010303@gmail.com> <51CB1356.80306@lwfinger.net> <51CB250A.3060900@gmail.com> <51CB4E31.50502@lwfinger.net> <51CC0CD1.5000801@gmail.com> <51CC3F6E.4050308@gmail.com>
In-Reply-To: <51CC3F6E.4050308@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/27/2013 08:34 AM, Xose Vazquez Perez wrote:
> On 06/27/2013 11:58 AM, shiki.biomernok wrote:
>
>> @Xose: What does that mean for me? Am I trying the wrong driver?
>
> No, that should be the correct driver.
> But it looks like rtl8192cu wasn't tested enough with 2T2R(RTL8192CUS)
> devices.

The code in wireless-testing works fine on my Edimax EW-7811Un, which reports as 
an RTL8192CUS. If someone wants to send me an 8200ND, I'll make it work. Note: 
Realtek does not supply me with samples of USB devices.

Larry



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:34582 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967Ab3BOOWy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2013 09:22:54 -0500
Message-ID: <511E44B8.3000308@qca.qualcomm.com> (sfid-20130215_152258_533663_7630BA09)
Date: Fri, 15 Feb 2013 19:52:48 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Julien Massot <jmassot@aldebaran-robotics.com>
CC: Kalle Valo <kvalo@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <ath6kl-devel@qca.qualcomm.com>
Subject: Re: ath6kl: AR6004 failed to start on computer boot
References: <CADGp=QfF1bBgqP_X9=+PXfH0xCgPFn=h2VG19uV8_cJ8xzg8gg@mail.gmail.com> <87ehghanxe.fsf@kamboji.qca.qualcomm.com> <CADGp=Qf=j+kWA4EM1Z-xyKkuutW64Fi0vfUNqm1tPM1+4WEKyQ@mail.gmail.com>
In-Reply-To: <CADGp=Qf=j+kWA4EM1Z-xyKkuutW64Fi0vfUNqm1tPM1+4WEKyQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 02/15/2013 07:40 PM, Julien Massot wrote:
> Hi Kalle
>
>> IIRC you mentioned on IRC that you don't see this anymore, is that
>> correct?
>
> I still have the problem on a reboot, but the device initialize itself
> properly after a normal boot.
>
> It's still a problem for me, I obtain exactly the same log.
> ath6kl: Failed to start hardware: -5
> Dec 13 01:43:21 x201 kernel: [   24.843781] ath6kl: Failed to init
> ath6kl core: -5
> Dec 13 01:43:21 x201 kernel: [   24.843849] ath6kl_usb: probe of
> 2-1.2:1.0 failed with error -5

In x86 I remember this issue can be seen, I will try to take
a look at this by finding some time :)

>
> If you need to test anything don't hesitate to request me.
>
>

-- 
thanks,
shafi

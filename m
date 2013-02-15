Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:62396 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967Ab3BOOKp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2013 09:10:45 -0500
Received: by mail-wg0-f44.google.com with SMTP id dr12so2828446wgb.35
        for <linux-wireless@vger.kernel.org>; Fri, 15 Feb 2013 06:10:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87ehghanxe.fsf@kamboji.qca.qualcomm.com>
References: <CADGp=QfF1bBgqP_X9=+PXfH0xCgPFn=h2VG19uV8_cJ8xzg8gg@mail.gmail.com>
	<87ehghanxe.fsf@kamboji.qca.qualcomm.com>
Date: Fri, 15 Feb 2013 15:10:43 +0100
Message-ID: <CADGp=Qf=j+kWA4EM1Z-xyKkuutW64Fi0vfUNqm1tPM1+4WEKyQ@mail.gmail.com> (sfid-20130215_151049_077689_4C5782BA)
Subject: Re: ath6kl: AR6004 failed to start on computer boot
From: Julien Massot <jmassot@aldebaran-robotics.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath6kl-devel@qca.qualcomm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle

> IIRC you mentioned on IRC that you don't see this anymore, is that
> correct?

I still have the problem on a reboot, but the device initialize itself
properly after a normal boot.

It's still a problem for me, I obtain exactly the same log.
ath6kl: Failed to start hardware: -5
Dec 13 01:43:21 x201 kernel: [   24.843781] ath6kl: Failed to init
ath6kl core: -5
Dec 13 01:43:21 x201 kernel: [   24.843849] ath6kl_usb: probe of
2-1.2:1.0 failed with error -5

If you need to test anything don't hesitate to request me.

Regards,

-- 
Julien

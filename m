Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:51677 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754801Ab2EQGZd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 May 2012 02:25:33 -0400
Received: by obbwd20 with SMTP id wd20so2501681obb.4
        for <linux-wireless@vger.kernel.org>; Wed, 16 May 2012 23:25:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FB12E62.4030905@gmail.com>
References: <4FB12E62.4030905@gmail.com>
Date: Thu, 17 May 2012 09:25:31 +0300
Message-ID: <CANJm+iAxcPrgJfx_03P1L-G7YFdPDK7B-aRXDgbpand0XgULVA@mail.gmail.com> (sfid-20120517_082537_621960_97033616)
Subject: Re: wl12xx: extend survey with channel_time_tx, channel_busy_time and channel_time
From: "Divinsky, Yonatan" <yoni.divinsky@ti.com>
To: =?ISO-8859-1?Q?Mustafa_Y=FCcel?= <yuecelm@gmail.com>
Cc: coelho@ti.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 14, 2012 at 7:10 PM, Mustafa Yücel <yuecelm@gmail.com> wrote:
> Hi Yoni,
>
Hi Mustafa,

> I try to get this feature working with hostapd and wl12xx:
> http://linuxwireless.org/en/users/Documentation/acs
>
> currently only the noise of the main channel is filled within the
> wl1271_op_get_survey function. but to get acs working, in need to fill
> channel_time, channel_time_tx and channel_busy_time in the survey. is it
> somehow possible to get these values (or similar values like a duty
> cycle value) from the firmware? the only requirement I see as far, is
> that it should measure these values inside a ROC phase...
>

I checked and currenty I don't see a possiblity to get this parameter,
I am trying to find out with the firmware team. I don't quite
understand what the parameter stand for.
for example what does channel_time_tx exactly mean?

Thanks,
Yoni

> Thanks,
> Musti

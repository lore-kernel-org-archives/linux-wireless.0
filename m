Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62900 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770Ab1BCWkB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Feb 2011 17:40:01 -0500
Received: by iyj18 with SMTP id 18so1558726iyj.19
        for <linux-wireless@vger.kernel.org>; Thu, 03 Feb 2011 14:40:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <f65439b7f2e5843eb18b7880ba64adb959b87c11.1296769444.git.chunkeey@googlemail.com>
References: <cb1597685120e228d2c66a7eafc07aed1466f7dd.1296769444.git.chunkeey@googlemail.com>
 <f65439b7f2e5843eb18b7880ba64adb959b87c11.1296769444.git.chunkeey@googlemail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 4 Feb 2011 09:39:40 +1100
Message-ID: <AANLkTin=AxaG=bvV6pr18tZ0SpHpU21adzeHFm=gei8W@mail.gmail.com>
Subject: Re: [RFT/RFC] carl9170: export HW random number generator
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 4, 2011 at 08:30, Christian Lamparter
<chunkeey@googlemail.com> wrote:
> All AR9170 hardware have a 16-Bit random number generator.
> The documentation claims the values are suitable for
> "security keys".
>
> This is an early, but working version. The "throughput" is
> around 320Kibit/s. It's slow, but it will work without
> introducing any special offload firmware commands.

Would it not be better to cut down on the #ifdefs and move this
functionality into a separate file?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/

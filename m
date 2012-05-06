Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:37688 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752148Ab2EFIOL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 May 2012 04:14:11 -0400
Received: by lahj13 with SMTP id j13so2843913lah.19
        for <linux-wireless@vger.kernel.org>; Sun, 06 May 2012 01:14:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FA60D43.1010202@Magitekindustries.com>
References: <4FA60D43.1010202@Magitekindustries.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Sun, 6 May 2012 18:13:48 +1000
Message-ID: <CAGRGNgXJ5Nk_7cf_meHRP9uL1iNTER+Snuzg-8rrp-=-jTjhaQ@mail.gmail.com> (sfid-20120506_101417_584741_A651DF7D)
Subject: Re: Intel 2200BG/Linux
To: DC <DC@magitekindustries.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Sun, May 6, 2012 at 3:33 PM, DC <DC@magitekindustries.com> wrote:
>    I'm having the hardest time in the world getting this card to work
> with Linux. Can you help me?

You need to use the ipw2200 driver, and you need the firmware.

The driver should already be in your distro's kernel, and the firmware
should be available through it's package repository.

E.g. in Debian, the firmware is available in the firmware-ipw2x00 package.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41331 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756833Ab0JAOhG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Oct 2010 10:37:06 -0400
Received: by fxm14 with SMTP id 14so612701fxm.19
        for <linux-wireless@vger.kernel.org>; Fri, 01 Oct 2010 07:37:04 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Saqeb Akhter <saqeb.akhter@gmail.com>
Subject: Re: carl9170: wnda3100 only 54MB/s
Date: Fri, 1 Oct 2010 16:36:57 +0200
Cc: linux-wireless@vger.kernel.org
References: <AANLkTimN3X_e4fZhUSoTs-GmQ9kmaJUrgnxAu8=W2dT_@mail.gmail.com> <AANLkTinpJ2qzR3D6Oe1WOS60sfRergfH548EMdB2m=_P@mail.gmail.com>
In-Reply-To: <AANLkTinpJ2qzR3D6Oe1WOS60sfRergfH548EMdB2m=_P@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201010011636.58033.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 01 October 2010 16:22:45 Saqeb Akhter wrote:
> Hey Guys,
> 
> I just got around to compiling compat-wireless on ubuntu 10.04, to
> make use of the new carl9170 driver which is supposed to be able to
> handle 802.11n.
> 
> My router is a wndr3700 running @ 5ghz on windows I'm able to get
> pretty good speeds. But on Ubuntu it does not seem to connect faster
> than 54MB/s, iwlist scan shows that 54Mb/s is the highest it can go.
sure, that's a limitation of iwlist. If you want to know the current
link speed (link speed as in "the last used tx rate", so if there's
no traffic then the rate is low) you should be using the "iw" utility:

iw dev wlanX link

Regards,
	Chr

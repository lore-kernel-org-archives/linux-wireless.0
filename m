Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:55352 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752362Ab2BUJ6N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Feb 2012 04:58:13 -0500
Received: by lahi5 with SMTP id i5so10382984lah.18
        for <linux-wireless@vger.kernel.org>; Tue, 21 Feb 2012 01:58:10 -0800 (PST)
Message-ID: <1329818288.22736.13.camel@cumari> (sfid-20120221_105817_274462_97D59FEB)
Subject: Re: Kernel panic after reboot with wifi enabled
From: Luciano Coelho <coelho@ti.com>
To: Yingang Fu <yingang.fu@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 21 Feb 2012 11:58:08 +0200
In-Reply-To: <CAHPDcRvkopS0-5bXRpULEYvo9KBt=Mrp9o4ssoRdbVgia9qE1w@mail.gmail.com>
References: <CAHPDcRvkopS0-5bXRpULEYvo9KBt=Mrp9o4ssoRdbVgia9qE1w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-02-21 at 16:20 +0800, Yingang Fu wrote: 
> hi, all
> 
> My platform equipped with a wl1271 wireless chip. The system crashed
> randomly with following error messages when reboot the system
> with wifi enabled.
> 
> From the log, i found that there is a sdio_bus_remove function call in
> the stack.
>  I'm confused about that.
> Does anybody know what happened to my driver?

We don't have enough information here to know what is really happening.

What platform are you using? Looking at the register dump this seems to
be x86, right? What is the kernel version you are using? How is the
wl1271 card connected to your platform?


-- 
Cheers,
Luca.


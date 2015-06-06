Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34530 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbbFFN1v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Jun 2015 09:27:51 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Yegor Yefremov <yegorslists@googlemail.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Machani\, Yaniv" <yanivma@ti.com>,
	Eliad Peller <eliad@wizery.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: Re: wl18xx: wlconf kernel compatibility
References: <CAGm1_kt1FfO=juFvwRP6CQU7_YTf2WQcQEgHfNAVkW=PSKMAzQ@mail.gmail.com>
Date: Sat, 06 Jun 2015 16:27:43 +0300
In-Reply-To: <CAGm1_kt1FfO=juFvwRP6CQU7_YTf2WQcQEgHfNAVkW=PSKMAzQ@mail.gmail.com>
	(Yegor Yefremov's message of "Tue, 26 May 2015 12:09:51 +0200")
Message-ID: <87bngtnf00.fsf@kamboji.qca.qualcomm.com> (sfid-20150606_152929_364064_03781C55)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yegor Yefremov <yegorslists@googlemail.com> writes:

> How do I know, which wlconf version is compatible with which kernel
> version? I have following problem:
>
> I have *.INI file for my particular WLAN chip. This file will be used
> to produce wl18xx-conf.bin. The size of this file will be check during
> device initialization. Depending on which kernel version is used the
> size of the required file differs. For example kernel 3.18 requires
> wl18xx-conf.bin to have 1221 bytes, 4.1 expects 1226 bytes. Recent
> wlconf (git://git.ti.com/wilink8-wlan/18xx-ti-utils.git) produces 1229
> bytes files.
>
> How should I determine correct wlconf version?

I also complained about something along these lines earlier, this is not
how upstream drivers are supposed to work. Users should not be forced to
find correct files from somewhere, instead everything should just work
out of box.

Can anyone help Yegor to solve his problem? But in the long run wl18xx
really should manage this better.

-- 
Kalle Valo

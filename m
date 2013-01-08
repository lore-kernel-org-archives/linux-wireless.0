Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:35080 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695Ab3AHWRm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jan 2013 17:17:42 -0500
Received: by mail-wg0-f53.google.com with SMTP id fn15so712643wgb.20
        for <linux-wireless@vger.kernel.org>; Tue, 08 Jan 2013 14:17:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJ-Vmom8XFaPwOamGwqcG1sZaDyjodUbhgPFNHONBAYnr1eEBA@mail.gmail.com>
References: <1357652938-18836-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	<CAJ-VmomJiw8cZqiPRCa8iDrTJdhwtWTTVQwMcHnnyft+DquR1Q@mail.gmail.com>
	<CAJ-Vmom8XFaPwOamGwqcG1sZaDyjodUbhgPFNHONBAYnr1eEBA@mail.gmail.com>
Date: Tue, 8 Jan 2013 14:17:40 -0800
Message-ID: <CAJ-Vmomz-iqz5h-rdzd9Z-0DQdMrWBq2cdXq+DHvNUrVWmS0Gw@mail.gmail.com> (sfid-20130108_231749_027110_8D577BEC)
Subject: Re: [PATCH] ath9k: add spectral scan feature
From: Adrian Chadd <adrian@freebsd.org>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org,
	Zefir Kurtisi <zefir.kurtisi@neratec.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

.. my turn to impress :-)

I've peverted your code in the worst possible way and made it work on
a live data stream.

http://people.freebsd.org/~adrian/ath/fft_snapshot_5ghz.png

:-)

I have FreeBSD's ath driver now enabling and triggering spectral scan
(if configured this way) on each channel reset/change, so I can gather
spectral samples during a scan.

I'll tinker with this a little more, but I'm honestly at the point
where I think you and I should just agree on a javascript-friendly
encoding scheme and write a HTTP server app that just reads in a live
or recorded data stream, then feeds it serialised out HTTP. That way
people can just write HTML5 renderers (which leverage all the
GL/accelaration they want) and we can benefit from having a shared
visualisation tool. :-)

What do you think?



Adrian

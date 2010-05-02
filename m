Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:42280 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755390Ab0EBHr2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 May 2010 03:47:28 -0400
Message-ID: <4BDD2E05.40203@free.fr>
Date: Sun, 02 May 2010 09:47:17 +0200
From: Benoit Papillault <benoit.papillault@free.fr>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: "David H. Lynch Jr." <dhlii@dlasys.net>,
	linux-wireless@vger.kernel.org
Subject: Re: ar9170-fw II
References: <4BDC001F.9050202@dlasys.net> <201005011919.32016.chunkeey@googlemail.com> <4BDC719E.3060505@dlasys.net> <201005012245.36589.chunkeey@googlemail.com>
In-Reply-To: <201005012245.36589.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Le 01/05/2010 22:45, Christian Lamparter a écrit :
> On Saturday 01 May 2010 20:23:26 David H. Lynch Jr. wrote:
>> I think I can tell you what I am supposed add - I need to be able
>> to provide userspace apps with precise timing information for each packet.
>> Since i am working on GPL'd code and the results are going to be
>> provided to third parties whatever I do is GPL'd too.
>
> if by precise timing you mean "exact mac time in TU/usecs when frame
> was received at the radio", then you might have a _problem_.
> You see, the firmware already receives fully packed frames from
> the MAC processor and only _forwards_ them all [as is] in
> one big DMA to the USB subsystem.
> (this is done in src/wlan.c handle_rx())
>
> So, unless the HW has a _magic_ flag to enable this capability...
> you are sort of screwed :-/.

I would love this feature as well. I have a device to test if that can 
help. I share the feeling of Christian however... but maybe your 
documentation says something about a special flag.

Regards,
Benoit

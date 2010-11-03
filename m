Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:37494 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679Ab0KCABF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Nov 2010 20:01:05 -0400
Received: by gwj21 with SMTP id 21so28885gwj.19
        for <linux-wireless@vger.kernel.org>; Tue, 02 Nov 2010 17:01:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4CD0A583.40105@lwfinger.net>
References: <309278.75116.qm@web29520.mail.ird.yahoo.com>
	<4CCF7B73.7040906@lwfinger.net>
	<4CCF7EFC.1050000@mandriva.com.br>
	<AANLkTinEsp+-EU4Oau71qHbL6ftO544+H4GA3WZk7CX5@mail.gmail.com>
	<4CD0A583.40105@lwfinger.net>
Date: Tue, 2 Nov 2010 22:01:00 -0200
Message-ID: <AANLkTin937V6hJ4L2o-SF5riTh0MpTd3e6faZnbZuV48@mail.gmail.com>
Subject: Re: [PATCH 3/9] rtl8187: fix wrong register initialization in 8187B
From: Rogerio Luz Coelho <rogluz.news@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/11/2 Larry Finger <Larry.Finger@lwfinger.net>:
> On 11/02/2010 06:48 PM, Rogerio Luz Coelho wrote:
>> Ok, I see the 8187b is in development.
>>
>> But PLEASE ask Thadeu Cascardo for his patch as it seems to fix the
>> issue with these cards when connected to Laptop (Positivo Laptops in
>> Brasil for instance), this would even let the Mandriva folks show
>> Positivo that they don't need to ship the Mandriva 2008.0 woith their
>> Linux Laptops anymore ...
>>
>> the patch he sent me FIXED the problem where the chip did not connect
>> or when it did it would lose the connection right away...
>>
>> see
>> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/215802?comments=all
>>
>>
>> I haven´t aplied any other patches and the one he sent me JUST WORKS,
>> tested in a Ubuntu 10.04 64bit (64bit being important since the
>> Realtek support told me they did NOT support 64bit with their linux
>> drivers)
>
> Realtek does not support 64-bit systems with most of their drivers, but we do.
> In fact, I only do development on x86_64 and then test on i386.
>
> Obviously, there is something special about the Toshiba/Brazil devices. The
> patch that you need to make a cdonnection had absolutely no effect on mine.
>
> Larry
>

No effect is better than "regression" right?

I am not saying the chip got magically better, it still seems a cheap
POS, but with Cascardo's patch is as good as the Win7 driver here.

Rogerio

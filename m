Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:38973 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753560Ab0CDHj3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Mar 2010 02:39:29 -0500
Received: by wwa36 with SMTP id 36so1265482wwa.19
        for <linux-wireless@vger.kernel.org>; Wed, 03 Mar 2010 23:39:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B8F5228.4080001@freemail.hu>
References: <4B8F5228.4080001@freemail.hu>
Date: Thu, 4 Mar 2010 07:39:28 +0000
Message-ID: <efe7343f1003032339x32bd512et9eebe0518546cfee@mail.gmail.com>
Subject: Re: Linux 2.6.33 + Edimax EW-7318Ug?
From: Luis Correia <luis.f.correia@gmail.com>
To: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

2010/3/4 Németh Márton <nm127@freemail.hu>:
> Hi,
>
> I'm new to the Edimax EW-7318Ug ( http://www.edimax.com/en/produce_detail.php?pd_id=3&pl1_id=1&pl2_id=44 )
> device. I could find out so far that there are different drivers for Linux
> which can be used with this device. I think this device have the RT73 chip.
>
> I tried Linux kernel 2.6.33, compiled with CONFIG_RT2X00=m and CONFIG_RT2X00_DEBUG=y
> (the full kernel config is attached). I copied the rt73.bin from
> http://www.edimax.com/images/Image/driver/Linux%20driver/Wireless/USB%20adaptor/2008_0506_RT73_Linux_STA_Drv1.1.0.1.tar.zip
> to /lib/firmware/rt73.bin .

While I'm not 100% sure, this may be one of those devices thas has
it's ID in both rt2500usb and rt73usb.

Besides prying it open to see which is the actual chip used, there is
little we can do, software side, to be sure of which exact driver
should be used.

But to be honest, I can't really recall which exact driver ID conflict.

Luis Correia
rt2x00 project admin

[snipped the rest of the email]

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.25]:51588 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630AbZGTMDV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jul 2009 08:03:21 -0400
Received: by qw-out-2122.google.com with SMTP id 8so819724qwh.37
        for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2009 05:03:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1247843954.25608.62.camel@mj>
References: <6306c640907142221o27c257aaw12f73da8118376f@mail.gmail.com>
	 <445f43ac0907151344q6d80ddeckc0c586b34d8ca7c5@mail.gmail.com>
	 <6306c640907152338k4a5fb474h481d5adba97507b1@mail.gmail.com>
	 <1247843954.25608.62.camel@mj>
Date: Mon, 20 Jul 2009 17:33:19 +0530
Message-ID: <6306c640907200503h19dcfdd1o8fc69cd94ebdc44f@mail.gmail.com>
Subject: Re: any controller working in AP mode ?
From: Ram kumar <ramkumar.research@gmail.com>
To: Pavel Roskin <proski@gnu.org>
Cc: Javier Cardona <javier@cozybit.com>, andrey@cozybit.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi,

> 5 minute search finds that Zonet ZEW2502 is what you need.  There is
> only one driver for that device on the Zonet site, and it's clearly for
> Marvell.
>
Thanks for the reply.
but when i visited the zonet website the ZEW2502 is under discontinued
products.But they have come up with higher versions of wireless usb
adapters like.

1.ZEW2542
http://www.zonetusa.com/products-140.aspx

ZEW2542 it uses Ralink RT2770+RT2720.
When i study the user manual of ZEW2542 it says it can support
software AP mode.The device uses Ralink wireless configuration tool
instead of the native windows wireless configuration tool to configure
the device.

but linux wireless website doesn't specify any info about RT2770.It
would he helpful if you can tell me whether the ZEW2542 can be
configured with hostapd ?

2.ZEW2507
http://www.zonetusa.com/products-54.aspx

ZEW2507 uses Chipset  	Ralink RT2571 + RT2528

I am assuming this device can be easily configured in linux using
hostapd.please correct me if i am wrong.

Regards,
Ram

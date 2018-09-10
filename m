Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Gamera.Varna.Net ([217.145.80.8]:38300 "EHLO Gamera.varna.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728778AbeIKAGb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Sep 2018 20:06:31 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Mon, 10 Sep 2018 21:10:53 +0200
From: pavlin@varna.net
To: Rami Rosen <roszenrami@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Troubleshooting compilation of hostapd
In-Reply-To: <CAKoUArkrfS=KiL=Rc5wbOrcdZ11zZB60hGOmgb7WST8d6V5FOw@mail.gmail.com>
References: <385bc6f25c5d82d2c36c518dbea8f76b@varna.net>
 <CAKoUArkrfS=KiL=Rc5wbOrcdZ11zZB60hGOmgb7WST8d6V5FOw@mail.gmail.com>
Message-ID: <09275c105c7a5f40ae6f067d465dbfb9@varna.net> (sfid-20180910_211203_830343_1F798AA1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Rami,

When I delete the project's directory
and  I clone the project again
and  I compile it with uncommented parameter "CONFIG_LIBNL32=y"
then the compilation is successful.

Thanks for the advice.

> HI Pavlin,
> Please try from scratch cloning the tree from scratch, then
> cp defconfig .config, then
> uncomment the following entry in .config:
> CONFIG_LIBNL32=y
> and then run "make", and post here the results.
> 
> Regards,
> Rami Rosen
> http://ramirose.wixsite.com/ramirosen

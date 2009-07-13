Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f228.google.com ([209.85.218.228]:38184 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756864AbZGMU7I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jul 2009 16:59:08 -0400
Received: by bwz28 with SMTP id 28so418936bwz.37
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jul 2009 13:59:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200907132246.51260.ssorgatem@esdebian.org>
References: <328c675a0907121316r7dacda0fr94b3b56a6c023d86@mail.gmail.com>
	 <3ace41890907131323t10c5bc15oac1714e63289abd@mail.gmail.com>
	 <200907132246.51260.ssorgatem@esdebian.org>
Date: Mon, 13 Jul 2009 21:59:07 +0100
Message-ID: <3ace41890907131359m1e33a8b7g629064c44c176b0@mail.gmail.com>
Subject: Re: Add device string to zd1211rw
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: ssorgatem@esdebian.org
Cc: dsd@gentoo.org, kune@deine-taler.de, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/7/13 Adrià Cereto Massagué <ssorgatem@gmail.com>:

> I'm not sure if this is what you need, but here it is:
>
> ssorgatem@sobremesakubuntu:~$ dmesg | grep -i zd1211rw
> [   10.045331] zd1211rw 1-2:1.0: phy0
> [   10.045390] usbcore: registered new interface driver zd1211rw
> [   13.184194] zd1211rw 1-2:1.0: firmware version 4725
> [   13.224200] zd1211rw 1-2:1.0: zd1211b chip 083a:e501 v4810 high 00-1a-2a
> AL2230_RF pa0 g--NS

Good - The AL2230_RF line is what I asked for.

Hin-Tak

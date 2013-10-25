Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:51712 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085Ab3JYKbs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Oct 2013 06:31:48 -0400
Received: by mail-ee0-f49.google.com with SMTP id e52so68736eek.22
        for <linux-wireless@vger.kernel.org>; Fri, 25 Oct 2013 03:31:47 -0700 (PDT)
Message-ID: <526A488C.9050705@gmail.com> (sfid-20131025_123202_981313_D1BB31FD)
Date: Fri, 25 Oct 2013 12:31:40 +0200
From: Pontus Fuchs <pontus.fuchs@gmail.com>
MIME-Version: 1.0
To: =?UTF-8?B?WWFubmlrIFbDtmxrZXI=?= <yannikv@yahoo.de>,
	Oleksij Rempel <linux@rempel-privat.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ar5523 Gigaset USB Adapter 108 issue
References: <Pine.LNX.4.44L0.1310181041080.1164-100000@iolanthe.rowland.org> <52614E9B.6040400@rempel-privat.de> <526155ED.1090007@yahoo.de> <52615EFA.80902@rempel-privat.de> <526162ED.8030901@yahoo.de> <52616CD0.2000203@rempel-privat.de> <5262789D.8030704@yahoo.de> <5262BA7A.2050803@rempel-privat.de> <5266C4C1.80408@yahoo.de> <5266C7BF.20503@rempel-privat.de> <526916A9.2050002@yahoo.de>
In-Reply-To: <526916A9.2050002@yahoo.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> as reported the connection sometimes breakes down, when that happens
> the dmesg contains multiple repetitions of the line
> [ 9577.930431] usb 3-14: ar5523_data_rx_cb: USB err: -2

Hi,

Can you reproduce your problem with debugging enabled for the ar5523 driver:

As root execute:

echo "module ar5523 +p" > /sys/kernel/debug/dynamic_debug/control

Cheers,

Pontus



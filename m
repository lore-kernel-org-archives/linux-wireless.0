Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f52.google.com ([209.85.192.52]:35718 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850AbaIKI5B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2014 04:57:01 -0400
Received: by mail-qg0-f52.google.com with SMTP id i50so5858674qgf.25
        for <linux-wireless@vger.kernel.org>; Thu, 11 Sep 2014 01:57:01 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 11 Sep 2014 10:57:00 +0200
Message-ID: <CAAfyv35k1mgQh6FcWaaMciAo8Vkp055k=5xF7zu+yrHmrQbbLA@mail.gmail.com> (sfid-20140911_105710_866444_B96164C0)
Subject: mwifiex_usb_submit_rx_urb: dev_alloc_skb failed when conected to 5GHz
From: Belisko Marek <marek.belisko@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: akarwar@marvell.com, patila@marvell.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I'm using 3.9 mainline mwifiex driver for wireless usb card. Doing
some throughput testing (with iperf) in 5GHz I got following failures:
[ 221.521799] usb 1-1: mwifiex_usb_submit_rx_urb: dev_alloc_skb failed

I checked which which size fails to allocate and it's 4096 bytes. I
was looking to changes in never kernel releases but I cannot find
anything obvious. When connected to 2.4GHz I cannot reproduce issue
though. I'm using FW version mwifiex 1.0 (14.68.29.p26).

Thank for any help/hints,

BR,

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
twitter: #opennandra
web: http://open-nandra.com

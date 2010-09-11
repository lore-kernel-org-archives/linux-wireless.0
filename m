Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58251 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046Ab0IKR4h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Sep 2010 13:56:37 -0400
Received: by wwb13 with SMTP id 13so1618400wwb.1
        for <linux-wireless@vger.kernel.org>; Sat, 11 Sep 2010 10:56:36 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 11 Sep 2010 14:56:35 -0300
Message-ID: <AANLkTinzxdFYBiuEE83o0_00q2dLieFqOBZ-KcfY2EA5@mail.gmail.com>
Subject: [ ath5k/ath9k ] led/bluetooth problem on hp pavillion machines.
From: Leonardo <sombriks@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hello all,
i'm using 2.6.35.5 and those laptops, which have a led that is also a
buttom, so when i touch it the wifi and bluetooth shuts down but when
i press it again only wifi returns to work.

it worked pretty well on older kernels, like 2.6.29 and 31, but
starting from 32 - nowadays led started to blink (it didn't blinked
before, it was blue to on, orange to off) and just reactivates wifi.

i don't know how send proper info for debug, actually i have figured
how to compile a kernel and install it properly, but that's all.

one machine uses ath5k and the other uses ath9k, both the very same
problem. thanks in advance.

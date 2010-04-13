Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35865 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab0DMFro (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Apr 2010 01:47:44 -0400
Received: by wyf19 with SMTP id 19so28431wyf.19
        for <linux-wireless@vger.kernel.org>; Mon, 12 Apr 2010 22:47:43 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 13 Apr 2010 06:47:42 +0100
Message-ID: <u2u719bd8781004122247kb48bedet36ea07db3819d202@mail.gmail.com>
Subject: p54pci does not work
From: Duarte Nuno Gomes <dnunogomes@gmail.com>
To: linux-wireless@vger.kernel.org, chunkeey@googlemail.com
Cc: flamingice@sourmilk.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi,

im a p54pci module user.
02:01.0 Network controller: Intersil Corporation ISL3890 [Prism GT/Prism
Duette]/ISL3886 [Prism Javelin/Prism Xbow] (rev 01)

i use isl3886pci firmware ( 2.13.12.0.arm ) and used the latest
compat-wireless-2.6.34-rc4-test1
latest firmware , 2.17.2.0.arm wont work

it works all ok ... when i visit some websites ( www.rcmadeira.pt.vu is one
of them ), my connection just disconnects and i cannot resume it . i need to
shutdown and re lauch kernel in order to work with wireless again.

here is what dmesg outputs

No probe response from AP 00:24:17:6c:a5:0e after 500ms, disconnecting.
Phy0 : cannot boot firmware !

i've tryed modprobe -r p54pci and modprobe p54pci , wont work. needs a
complete shutdown.

its an annoying bug... i cannot browse sucessfully for some hours , some
will fail , making me reboot and reboot and reboot ...

if u need addicional information , please let me know to
dnunogomes@gmail.com
Hope it will be corrected soon
i would like to receive any update about this , thanks !

bye !

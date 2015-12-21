Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:33981 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbbLUMJ1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 07:09:27 -0500
Received: by mail-lb0-f180.google.com with SMTP id pv2so27885684lbb.1
        for <linux-wireless@vger.kernel.org>; Mon, 21 Dec 2015 04:09:26 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 21 Dec 2015 14:09:25 +0200
Message-ID: <CAJL_dMuDXMQYRpDAk9FOnTeA+4vsQARw8028DRrmKeRNeLQzug@mail.gmail.com> (sfid-20151221_130930_381279_9AADF4AF)
Subject: Mediatek wifi
From: Anca Emanuel <anca.emanuel@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Linus Walleij, and everyone interested.

http://askubuntu.com/questions/676390/no-wi-fi-on-ubuntu-14-04-lts-asus-notebook-with-mediatek-mt7630e

Here is the bug report:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1220146

https://github.com/neurobin/MT7630E is reported to work for wifi.

Maybe it works to add usb ids to
https://github.com/torvalds/linux/tree/master/drivers/net/wireless/rt2x00
and firmware.

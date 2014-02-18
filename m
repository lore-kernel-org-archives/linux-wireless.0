Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f170.google.com ([209.85.214.170]:38909 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070AbaBRBW6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Feb 2014 20:22:58 -0500
Received: by mail-ob0-f170.google.com with SMTP id va2so17785328obc.15
        for <linux-wireless@vger.kernel.org>; Mon, 17 Feb 2014 17:22:58 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 17 Feb 2014 19:22:58 -0600
Message-ID: <CABTQh0_eHk-9hvcfW_Cjr8xxJWGPKwf1m1BKs2-WnCtp4-i=Qw@mail.gmail.com> (sfid-20140218_022302_000784_C8CC00BD)
Subject: ath6kl: QCA6234 support
From: Curt Black <cblack@taoglas.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Greetings, I have been working with the QCA6234 chip, which is
basically a AR6004 on the wireless side.

Has anyone successfully used the ath6kl driver for this HW revision?
0x0271 : 0x0402 is the ID of the 6234 (current support is x400/x401
from what I see in sdio.c)

Perhaps this is a HW 1.4/2?  (ath6kl: Unsupported hardware version: 0x31c809f8)

I think the the Dragonboard uses a 6234, but collecting the source
there has proven ineffective.

cheers

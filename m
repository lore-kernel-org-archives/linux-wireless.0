Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f31.google.com ([209.85.219.31]:55384 "EHLO
	mail-ew0-f31.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbYK0BN3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2008 20:13:29 -0500
Received: by ewy12 with SMTP id 12so47667ewy.13
        for <linux-wireless@vger.kernel.org>; Wed, 26 Nov 2008 17:13:27 -0800 (PST)
Message-ID: <14c249940811261657l37d9855btc5280cd0e76e4525@mail.gmail.com> (sfid-20081127_021334_356017_7BF98D88)
Date: Thu, 27 Nov 2008 08:57:49 +0800
From: "c4linux c4linux" <c4linux@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: one VAP's WEP key overwrites another's
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

there is a question about AR2413 and madwifi driver.

madwifi can support VAP, so I setup 2 VAPs, one is ath0, another is
ath1.both of them are set SharedKey authentication and use WEP
encrypthion. I type the command below to set each of them a password:

iwconfig ath0 key [1] s:1111111111111
iwconfig ath1 key [1] s:2222222222222

two VAPs have the same mac address and their ssid are different.

the strange thing happens, It seems that ath1's password overwrite the
ath0's, so if I set my sta the ath1's password and select ath0 to
connect, I connect the ath0 successfully. Why? are the 4 slots for WEP
Key is shared by all VAPs?  or VAP is not stable?

Thank you!

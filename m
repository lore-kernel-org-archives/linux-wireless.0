Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f214.google.com ([209.85.217.214]:35539 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076AbZFIIlA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2009 04:41:00 -0400
Received: by gxk10 with SMTP id 10so2934738gxk.13
        for <linux-wireless@vger.kernel.org>; Tue, 09 Jun 2009 01:41:02 -0700 (PDT)
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 9 Jun 2009 01:40:42 -0700
Message-ID: <43e72e890906090140i2085acd1u40810468cbda2932@mail.gmail.com>
Subject: ath9k deadbeef on 0x806c
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I get these each time the drop_no_bitrate debugfs counter increases.
That should be a clue as to what may be triggering these.

ath9k: timeout (100000 us) on reg 0x806c: 0xdeadbeef & 0x01f00000 != 0x00000000
ath9k: RX failed to go idle in 10 ms RXSM=0xdeadbeef

I think this means you'll need a dual band card to trigger this and if
not using network manager trigger a scan every now and then, and also
enable PS by default.

  Luis

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f214.google.com ([209.85.217.214]:61038 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356AbZFIIto (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2009 04:49:44 -0400
Received: by gxk10 with SMTP id 10so2941322gxk.13
        for <linux-wireless@vger.kernel.org>; Tue, 09 Jun 2009 01:49:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890906090140i2085acd1u40810468cbda2932@mail.gmail.com>
References: <43e72e890906090140i2085acd1u40810468cbda2932@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 9 Jun 2009 01:49:26 -0700
Message-ID: <43e72e890906090149u678a7447q7bd3b0aad87b141f@mail.gmail.com>
Subject: Re: ath9k deadbeef on 0x806c
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 9, 2009 at 1:40 AM, Luis R. Rodriguez<mcgrof@gmail.com> wrote:
> I get these each time the drop_no_bitrate debugfs counter increases.
> That should be a clue as to what may be triggering these.
>
> ath9k: timeout (100000 us) on reg 0x806c: 0xdeadbeef & 0x01f00000 != 0x00000000
> ath9k: RX failed to go idle in 10 ms RXSM=0xdeadbeef
>
> I think this means you'll need a dual band card to trigger this and if
> not using network manager trigger a scan every now and then, and also
> enable PS by default.

Just saw this happen without the counter++

Luis

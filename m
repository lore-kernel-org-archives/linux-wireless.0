Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:46096 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755374Ab1FBGNv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jun 2011 02:13:51 -0400
Received: by qwk3 with SMTP id 3so230354qwk.19
        for <linux-wireless@vger.kernel.org>; Wed, 01 Jun 2011 23:13:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTinSdDZv7gshYfi4mK5N9K-E7vk3Yw@mail.gmail.com>
References: <1306918871-16965-1-git-send-email-zajec5@gmail.com>
	<BANLkTinSdDZv7gshYfi4mK5N9K-E7vk3Yw@mail.gmail.com>
Date: Thu, 2 Jun 2011 08:13:49 +0200
Message-ID: <BANLkTi=mbBiSOGbEZ4AEYqZgyvgW0oXKtw@mail.gmail.com> (sfid-20110602_081355_393600_9AB99DCD)
Subject: Re: [RFT][PATCH 3.0] ssb: fix PCI(e) driver regression causing oops
 on PCI cards
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Andreas Schwab <schwab@linux-m68k.org>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	=?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>,
	Christian Kujau <lists@nerdbynature.de>
Cc: b43-dev@lists.infradead.org, linuxppc-dev@ozlabs.org,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/6/1 Rafał Miłecki <zajec5@gmail.com>:
> 2011/6/1 Rafał Miłecki <zajec5@gmail.com>:
>> We were incorrectly executing PCIe specific workarounds on PCI cards.
>> This resulted in:
>> Machine check in kernel mode.
>> Caused by (from SRR1=149030): Transfer error ack signal
>> Oops: Machine check, sig: 7 [#1]
>
> John, I've tested this patch myself on my PCI BCM4318, including
> checking for 0xFFFFFFFF reads in MMIO dumps.
>
> The patch is correct, please take it for 3.0.

John, I'm afraid more and more people get angry at me because of this ;)

Christian Kujau confirmed this problem and fix.

-- 
Rafał

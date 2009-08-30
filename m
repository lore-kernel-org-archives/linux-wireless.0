Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f205.google.com ([209.85.217.205]:57946 "EHLO
	mail-gx0-f205.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832AbZH3SBf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Aug 2009 14:01:35 -0400
Received: by gxk1 with SMTP id 1so4389501gxk.17
        for <linux-wireless@vger.kernel.org>; Sun, 30 Aug 2009 11:01:37 -0700 (PDT)
From: Kunal Gangakhedkar <kunal.gangakhedkar@gmail.com>
To: Howard Chu <hyc@symas.com>
Subject: Re: ath9k DMA problems
Date: Sun, 30 Aug 2009 23:30:47 +0530
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
References: <4A958F45.40109@symas.com> <4A987F0F.9040905@symas.com>
In-Reply-To: <4A987F0F.9040905@symas.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200908302330.47391.kunal.gangakhedkar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 29 Aug 2009 6:36:23 am Howard Chu wrote:
> Am I the only one having these problems? ath9k hasn't worked well for me
> since 2.6.29.4; every snapshot since then has suffered from random drops.
> In 2.6.29.6 it at least would quickly reassociate. The current ones hang
> within 20-30 minutes of use and never come back. The compat-wireless
> snapshots have all been equally unusable.
>
> Howard Chu wrote:
> > Still seeing occasional hangs using the ath9k in 2.6.31-rc6, and even
> > worse using compat-wireless 2009-08-22. Today I got this which was even
> > more interesting:
> >
> > [369014.776586] wlan0: associate with AP 00:12:17:26:56:10 (try 1)
> > [369014.779197] wlan0: RX ReassocResp from 00:12:17:26:56:10 (capab=0x411
> > status=0 aid=2)
> > [369014.779197] wlan0: associated
> > [369472.707961] ath9k: DMA failed to stop in 10 ms AR_CR=0xdeadbeef
> > AR_DIAG_SW=0xdeadbeef
> >
> > This is on an HP dv5z laptop, it reports an AR9280 at boot.

Neither for me - I'm on an HP dv6 series laptop and have AR9285 chip.
I have also posted my logs to the ath9k-devel list, but yet to receive any 
further response.

The driver seems quite erratic - especially under heavy network load & also 
after pm-resume.

Admittedly, I haven't tried compat-wireless at all.

Kunal

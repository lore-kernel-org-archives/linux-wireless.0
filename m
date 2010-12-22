Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f45.google.com ([209.85.214.45]:37483 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943Ab0LVTWw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Dec 2010 14:22:52 -0500
Received: by bwz16 with SMTP id 16so6080885bwz.4
        for <linux-wireless@vger.kernel.org>; Wed, 22 Dec 2010 11:22:50 -0800 (PST)
MIME-Version: 1.0
From: Matt Turner <mattst88@gmail.com>
Date: Wed, 22 Dec 2010 19:22:22 +0000
Message-ID: <AANLkTi=GUN7=AQAAvmgADgwHtcquNiZbWEtgCoJpC4Fv@mail.gmail.com>
Subject: [ath9k] skbuff alloc of size 3872 failed
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Cc: Michael Guntsche <mike@it-loops.com>,
	Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With the ath9k driver, I get "skbuff alloc of size 3872 failed"

I hit this again today after not using wireless for quite sometime. It
looks like it was originally reported against 2.6.35-rc1. Eric Dumazet
provided a patch which fixed the issue, but apparently it's still not
upstream. Why is this?

If it is suitable for upstream inclusion, please take my Tested-by:
Matt Turner <mattst88@gmail.com>

https://patchwork.kernel.org/patch/104271/

Thanks,
Matt

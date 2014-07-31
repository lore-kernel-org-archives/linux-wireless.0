Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:59309 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753451AbaGaFz1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jul 2014 01:55:27 -0400
Received: by mail-la0-f47.google.com with SMTP id mc6so1642025lab.6
        for <linux-wireless@vger.kernel.org>; Wed, 30 Jul 2014 22:55:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABzetm2Af-_WD29MrejTUQOH9pqDzCGCj8JC9LqyuTp5dyrT9Q@mail.gmail.com>
References: <CABzetm2Af-_WD29MrejTUQOH9pqDzCGCj8JC9LqyuTp5dyrT9Q@mail.gmail.com>
From: Rohit Kumar <rkthebest@gmail.com>
Date: Thu, 31 Jul 2014 14:55:04 +0900
Message-ID: <CABzetm3EgZrvaL370TnCFgDfoeFKqJ-LfhnExSjNwPnW6-HM=Q@mail.gmail.com> (sfid-20140731_075530_599537_C7CCE6CC)
Subject: Fwd: cross compiling realtek 8188
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

i have compiled the driver for USB to wifi dongle which uses realtek
8188 chipset for ARM11.
it works fine but

iw wlan0 info
shows "no device found"

but iwconfig works fine.

also how can i add nl80211 support for the driver?
With Regards,

Rohit Kumar
+82 1073149173

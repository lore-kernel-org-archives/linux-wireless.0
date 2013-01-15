Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:42336 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767Ab3AOKVP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jan 2013 05:21:15 -0500
Received: by mail-wi0-f177.google.com with SMTP id hm2so2123355wib.16
        for <linux-wireless@vger.kernel.org>; Tue, 15 Jan 2013 02:21:14 -0800 (PST)
MIME-Version: 1.0
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Tue, 15 Jan 2013 15:50:54 +0530
Message-ID: <CABPxzYL1LM-XAAb1RomgcM=O9Ma=KJZcbmEgTA678FSFuT8QMg@mail.gmail.com> (sfid-20130115_112124_687568_C4A212A9)
Subject: Tx AMSDU Support
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>, nbd@openwrt.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

Is there any work in progress/planned related to Tx AMSDU logic in mac80211?
Even though only Rx is mandatory, but to test the Rx we need the Tx.

I see that the support is there in mwifiex(marvell's) driver. So is
there any patent/legal issue before we can implement one?

Regards,
Chaitanya T K.

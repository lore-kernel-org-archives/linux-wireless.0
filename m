Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.226]:47517 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758046AbYILUiN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Sep 2008 16:38:13 -0400
Received: by rv-out-0506.google.com with SMTP id k40so961244rvb.1
        for <linux-wireless@vger.kernel.org>; Fri, 12 Sep 2008 13:38:12 -0700 (PDT)
Message-ID: <2da21fe50809121338s26106a07iddaa54faf3c68ada@mail.gmail.com> (sfid-20080912_223831_629870_6D7F86E5)
Date: Fri, 12 Sep 2008 22:38:12 +0200
From: "Davide Pesavento" <davidepesa@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: ath9k: unable to reset hardware
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

[ 4342.364205] ath_open: unable to reset hardware; hal status
4294967277 (freq 2437 flags 0x700e2)
[ 4342.364957] ath9k_start: Unable to complete ath_open
[ 4372.412478] ath_open: unable to reset hardware; hal status
4294967277 (freq 2437 flags 0x700e2)
[ 4372.420685] ath9k_start: Unable to complete ath_open
[ 4373.101414] ath_open: unable to reset hardware; hal status
4294967277 (freq 2437 flags 0x700e2)
[ 4373.102549] ath9k_start: Unable to complete ath_open

I'm using 2.6.27-rc5-wl-16606-g643e533 on a MacBookPro2,2 (AR5418).
rmmod ath9k && modprobe ath9k is enough to fix the issue, but
connectivity becomes a lot more unstable after that.

Regards,
Davide Pesavento

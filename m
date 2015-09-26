Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38932 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957AbbIZRia convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Sep 2015 13:38:30 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: Re: [PATCH] b43: probe bcma core (device) rev 0x15
References: <1441775802-1230-1-git-send-email-zajec5@gmail.com>
Date: Sat, 26 Sep 2015 20:38:23 +0300
In-Reply-To: <1441775802-1230-1-git-send-email-zajec5@gmail.com>
 (=?utf-8?Q?=22Rafa=C5=82=09Mi=C5=82ecki=22's?= message of "Wed, 9 Sep 2015
 07:16:42 +0200")
Message-ID: <877fnddqsw.fsf@kamboji.qca.qualcomm.com> (sfid-20150926_193832_596429_AB01EED7)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki <zajec5@gmail.com> writes:

> OpenWrt user reported b43 doesn't probe wireless core on SoC BCM5356A1:
> [    0.000000] bcma: bus0: Found chip with id 0x5356, rev 0x01 and package 0x04
> it is because this chip uses different 802.11 core revison than others:
> [    0.000000] bcma: bus0: Core 1 found: IEEE 802.11 (manuf 0x4BF, id 0x812, rev 0x15, class 0x0)
>
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>

Thanks, manually applied to wireless-drivers.git.

-- 
Kalle Valo

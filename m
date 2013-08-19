Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from forward3h.mail.yandex.net ([84.201.187.148]:42823 "EHLO
	forward3h.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215Ab3HSWgh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Aug 2013 18:36:37 -0400
Received: from web21h.yandex.ru (web21h.yandex.ru [84.201.187.155])
	by forward3h.mail.yandex.net (Yandex) with ESMTP id 7D1E0136101D
	for <linux-wireless@vger.kernel.org>; Tue, 20 Aug 2013 02:26:27 +0400 (MSK)
From: Yuri Pin <frt43@ya.ru>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Atheros 9280/AR9227 driver for kernel 2.6.21.7
MIME-Version: 1.0
Message-Id: <77051376951186@web21h.yandex.ru> (sfid-20130820_003640_286936_EFE8D217)
Date: Tue, 20 Aug 2013 02:26:26 +0400
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,
I have huawei wireless ONT modem with Atheros 9280 madwifi+carrier driver (found this in binnaries) and kernel 2.6.21.7. I can’t make it to connect to wireless networks as client. I guess that is because it doesn’t have wlan_scan_sta.ko kernel module (sta mode is available for wlanconfig but iwlist can scan only in ap mode). I tried also adhoc networking without success. There is no way I can compile wlan_scan_sta.ko module myself because it is necessary madwifi  with carrier SDK. I tried to compile compat-wireless-2.6.35-1 with enable-older-kernels patch but failed because a lot of symbols are missing in 2.6.21.7 (Huawei posted kernel sources, for example, there is no “ieee80211_ptr” symbol there).
1. Is there workaround to make Atheros working as wireless client without proper driver? Is there software that can do this (smth similar to aircrack?)
2. Any tips how compile driver for 2.6.21.7 kernel?
Thank you.

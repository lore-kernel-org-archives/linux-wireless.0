Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:56542 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932969Ab1JDSEU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Oct 2011 14:04:20 -0400
Received: by eya28 with SMTP id 28so747536eya.19
        for <linux-wireless@vger.kernel.org>; Tue, 04 Oct 2011 11:04:19 -0700 (PDT)
MIME-Version: 1.0
From: Jamie Kitson <jamie@kitten-x.com>
Date: Tue, 4 Oct 2011 19:03:59 +0100
Message-ID: <CA+z-pWFvBfvqY9_km8t3Xbmt=2Pw7eJo8T+SyFp=Lv=d1+ZOPw@mail.gmail.com> (sfid-20111004_200423_915320_308F4F45)
Subject: BUG: Soft lockup CPU#0 stuck for 22s! [wpa_supplicant:756]
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I get the following error when cold booting, it doesn't seem to happen
after a restart:

http://www.flickr.com/photos/jamiekitson/6211329161/

I have just moved my installation to a new machine with a:

03:00.0 Network controller: Realtek Semiconductor Co., Ltd. RTL8188CE
802.11b/g/n WiFi Adapter (rev 01)
        Subsystem: Realtek Semiconductor Co., Ltd. Device 8195
        Kernel driver in use: rtl8192ce
        Kernel modules: rtl8192ce

Linux jamie-laptop 3.0-ARCH #1 SMP PREEMPT Tue Aug 30 08:53:25 CEST
2011 x86_64 Intel(R) Core(TM) i5-2410M CPU @ 2.30GHz GenuineIntel
GNU/Linux

I am reporting it here as I assume it's a rtl8192ce bug, but if not I
can report it to the wpa_supplicant guys.

Thanks, Jamie

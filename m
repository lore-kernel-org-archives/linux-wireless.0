Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:38939 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754730Ab0K2ENP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Nov 2010 23:13:15 -0500
Received: by qyk12 with SMTP id 12so5801184qyk.19
        for <linux-wireless@vger.kernel.org>; Sun, 28 Nov 2010 20:13:15 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 29 Nov 2010 15:13:14 +1100
Message-ID: <AANLkTinS5M3YBj4f97F2+hiDTaxRbs-RM7D8q=M_T4qW@mail.gmail.com>
Subject: Hostapd + wpa_supplicant
From: linux newbie <linux.newbie79@gmail.com>
To: hostap@lists.shmoo.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

* On my embedded target, I am running rt73 based usb wireless adapter.
* tested hostapd and wpa_supplicant individually and it is working fine.
* bothe hostapd and wpa_supplicant are latest 0.7.3 versions with
libnl_1.1 version & kernel 2.6.35

If I run both wpa_supplicant and hostapd I am having issue.

Reason for running hostapd and wpa_supplicant on same terminal is we
have multiple wireless terminals and if one of them can't access the
AP (due to coverage issue) , then it will bind to Hostapd on some
other terminal. I am not sure, if I can able to configure my terminals
to use both hostapd & wpa_supplicant and need your expert advice.

Thanks

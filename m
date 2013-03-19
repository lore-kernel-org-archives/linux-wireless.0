Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f49.google.com ([209.85.214.49]:44953 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933015Ab3CSUyr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Mar 2013 16:54:47 -0400
Received: by mail-bk0-f49.google.com with SMTP id w11so442727bku.22
        for <linux-wireless@vger.kernel.org>; Tue, 19 Mar 2013 13:54:46 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 19 Mar 2013 21:54:46 +0100
Message-ID: <CAHwWuAE0MxN9_Bf1aTmpsefMAED-9HVsV7VtxorDvF3hSHZ2Ng@mail.gmail.com> (sfid-20130319_215452_367912_FFA689A8)
Subject: Intel Centrino Advanced-N 6205 master mode support
From: =?ISO-8859-1?B?ROluZXMgTultZXRo?= <mr.nemeth.denes@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

Could you help me the determine if the Intel Centrino Advanced-N 6205
is supported in AP / master mode?

Your website http://wireless.kernel.org/en/users/Drivers/iwlwifi states
that the "AP mode (experimental; only on some devices/firmware versions)"

Is the wifi card above supported?

Here is my debug info, at the bottom with the failure of changing to master mode
dmesg:
    loaded firmware version 18.168.6.1
    cfg80211: Regulatory domain changed to country: EU

iw list wlan0
    Supported interface modes:
         * IBSS
         * managed
         * AP
         * AP/VLAN
         * monitor
    software interface modes (can always be added):
         * AP/VLAN
         * monitor

iwconfig wlan0 mode master
Error for wireless request "Set Mode" (8B06) :
    SET failed on device wlan0 ; Invalid argument


Thanks, Denes

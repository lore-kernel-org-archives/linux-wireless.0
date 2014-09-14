Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yh0-f43.google.com ([209.85.213.43]:54247 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbaINBZy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Sep 2014 21:25:54 -0400
Received: by mail-yh0-f43.google.com with SMTP id v1so1368488yhn.30
        for <linux-wireless@vger.kernel.org>; Sat, 13 Sep 2014 18:25:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGLDHr5+SD3ENh81pB7pqMxSMm2J5TOWgjMpW+XiycvtEd776A@mail.gmail.com>
References: <CAGLDHr5+SD3ENh81pB7pqMxSMm2J5TOWgjMpW+XiycvtEd776A@mail.gmail.com>
Date: Sat, 13 Sep 2014 21:25:53 -0400
Message-ID: <CAGLDHr7uCtjfJR-d5RR80SbS5Es_c0PZG-od=sor4F+FARXLkA@mail.gmail.com> (sfid-20140914_032606_462437_C07A6C0C)
Subject: Fwd: N 6235 Input/Output Error
From: "roberto.waissman Waissman" <roberto.waissman@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On an Intel Galileo board:

dmesg | grep iw
[   25.039649] iwlwifi 0000:01:00.0: enabling device (0000 -> 0002)
[   25.045845] iwlwifi 0000:01:00.0: enabling bus mastering
[   25.046710] iwlwifi 0000:01:00.0: irq 45 for MSI/MSI-X
[   25.125172] iwlwifi 0000:01:00.0: loaded firmware version 18.168.6.1
[   25.353607] iwlwifi 0000:01:00.0: CONFIG_IWLWIFI_DEBUG disabled
[   25.359583] iwlwifi 0000:01:00.0: CONFIG_IWLWIFI_DEBUGFS disabled
[   25.365824] iwlwifi 0000:01:00.0: CONFIG_IWLWIFI_DEVICE_TRACING disabled
[   25.372648] iwlwifi 0000:01:00.0: CONFIG_IWLWIFI_DEVICE_TESTMODE disabled
[   25.379491] iwlwifi 0000:01:00.0: CONFIG_IWLWIFI_P2P enabled
[   25.385271] iwlwifi 0000:01:00.0: Detected Intel(R) Centrino(R)
Advanced-N 6235 AGN, REV=0xB0
[   25.407241] iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
[   25.640854] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'

 ifup wlan0
Successfully initialized wpa_supplicant
Could not set interface wlan0 flags (UP): Input/output error
WEXT: Could not set interface 'wlan0' UP
wlan0: Failed to initialize driver interface
ifconfig: SIOCSIFFLAGS: Input/output error

(again dmesg | grep iw)
.
.
[  111.160538] iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
[  111.173522] iwlwifi 0000:01:00.0: Radio type=0x2-0x1-0x0
[  111.366428] iwlwifi 0000:01:00.0: Microcode SW error detected.
Restarting 0x2000000.
[  111.374316] iwlwifi 0000:01:00.0: CSR values:
.
.


Thank you for your help,
Roberto.

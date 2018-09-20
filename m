Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr1-f45.google.com ([209.85.221.45]:42472 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732302AbeITT0X (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 15:26:23 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
From: Sedat Dilek <sedat.dilek@gmail.com>
Date: Thu, 20 Sep 2018 15:42:48 +0200
Message-ID: <CA+icZUXxcxZvyo7ge33E_1PSnjUs7Lq=BdcX2rbB6pYka1S=cA@mail.gmail.com> (sfid-20180920_154255_421490_F6C3A562)
Subject: acpi/iwlwifi: thermal thermal_zone3: failed to read out thermal zone (-61)
To: Zhang Rui <rui.zhang@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Cc: linux-acpi@vger.kernel.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I am seeing this with Linux v4.18.y and v4.19-rc4.

Investigating thermal_zone3...

# cat /sys/devices/virtual/thermal/thermal_zone3/type
iwlwifi

I have the following iwlwifi device and firmware installed...

[   10.476589] iwlwifi 0000:04:00.0: loaded firmware version
36.e91976c0.0 op_mode iwlmvm
[   10.519441] iwlwifi 0000:04:00.0: Detected Intel(R) Dual Band
Wireless AC 8265, REV=0x230

What informations do you need and how can I help?

Thanks.

Regards,
- Sedat -

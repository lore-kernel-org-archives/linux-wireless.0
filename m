Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bl2nam02on0085.outbound.protection.outlook.com ([104.47.38.85]:22592
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750916AbdBCQ2A (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Feb 2017 11:28:00 -0500
From: Bharat Kumar Gogada <bharat.kumar.gogada@xilinx.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "emmanuel.grumbach@intel.com" <emmanuel.grumbach@intel.com>,
        "matti.gottlieb@intel.com" <matti.gottlieb@intel.com>,
        "sara.sharon@intel.com" <sara.sharon@intel.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>
Subject: Issues with FW with Intel 720 wifi card
Date: Fri, 3 Feb 2017 16:27:47 +0000
Message-ID: <8520D5D51A55D047800579B094147198263E067A@XAP-PVEXMBX02.xlnx.xilinx.com> (sfid-20170203_172822_310137_38AAD573)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Im using linux 4.6 kernel, I get following error when I do interface up.

Here is the boot log.
[    4.407681] iwlwifi 0000:01:00.0: loaded firmware version 16.242414.0 op=
_mode iwlmvm
[    4.407742] iwlwifi 0000:01:00.0: Detected Intel(R) Wireless N 7260, REV=
=3D0x144
[    4.407831] iwlwifi 0000:01:00.0: L1 Disabled - LTR Disabled
[    4.408116] iwlwifi 0000:01:00.0: L1 Disabled - LTR Disabled

When I do interface up I get following :
[    9.419999] iwlwifi 0000:01:00.0: Failed to load firmware chunk!
[    9.425947] iwlwifi 0000:01:00.0: Could not load the [0] uCode section
[    9.432472] iwlwifi 0000:01:00.0: Failed to start INIT ucode: -110
[    9.438899] iwlwifi 0000:01:00.0: Failed to run INIT ucode: -110
[    9.444858] iwlwifi 0000:01:00.0: L1 Disabled - LTR Disabled


I downloaded firmware from here
https://wireless.wiki.kernel.org/en/users/Drivers/iwlwifi

Is there anything im missing ?

Regards,
Bharat

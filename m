Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44936 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750982AbdA2Oaq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 29 Jan 2017 09:30:46 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: linux-wireless@vger.kernel.org
Cc: linuxwifi@intel.com
Subject: Re: [regression] iwlwifi: crash in iwl_parse_tlv_firmware()
References: <87inoyt1ff.fsf@kamboji.qca.qualcomm.com>
Date: Sun, 29 Jan 2017 16:04:43 +0200
In-Reply-To: <87inoyt1ff.fsf@kamboji.qca.qualcomm.com> (Kalle Valo's message
        of "Sun, 29 Jan 2017 15:56:20 +0200")
Message-ID: <87efzmt11g.fsf@kamboji.qca.qualcomm.com> (sfid-20170129_153141_489889_13B55745)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> writes:

> updated the kernel on my test laptop and noticed that now iwlwifi
> crashes every time during boot. This is with tag ath-201701271935
> ath.git master branch, which essentially is wt-2017-01-27 from
> wireless-testing plus latest ath patches.
>
> I tried v4.10-rc5 and iwlwifi didn't crash so my guess is that this is a
> regression in the latest iwlwifi pull. Below is the crash log and the
> location in source. This is all I got via netconsole.

Forgot to include info about the device (from a working kernel):

[   17.911087] iwlwifi 0000:44:00.0: can't disable ASPM; OS doesn't have ASPM control
[   17.931205] iwlwifi 0000:44:00.0: loaded firmware version 39.31.5.1 build 35138 op_mode iwldvm
[   18.073590] iwlwifi 0000:44:00.0: CONFIG_IWLWIFI_DEBUG enabled
[   18.073679] iwlwifi 0000:44:00.0: CONFIG_IWLWIFI_DEBUGFS enabled
[   18.073757] iwlwifi 0000:44:00.0: CONFIG_IWLWIFI_DEVICE_TRACING enabled
[   18.073837] iwlwifi 0000:44:00.0: Detected Intel(R) Centrino(R) Wireless-N 1000 BGN, REV=0x6C
[   18.078383] iwlwifi 0000:44:00.0: L1 Enabled - LTR Disabled
[   19.359378] iwlwifi 0000:44:00.0 wlan1: renamed from wlan0

-- 
Kalle Valo

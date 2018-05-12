Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38458 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750735AbeELJ5k (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 12 May 2018 05:57:40 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Sriram R <srirrama@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] ath10k: DFS Host Confirmation
References: <1525110339-25326-1-git-send-email-srirrama@codeaurora.org>
        <1525110339-25326-3-git-send-email-srirrama@codeaurora.org>
Date: Sat, 12 May 2018 12:57:35 +0300
In-Reply-To: <1525110339-25326-3-git-send-email-srirrama@codeaurora.org>
        (Sriram R.'s message of "Mon, 30 Apr 2018 23:15:39 +0530")
Message-ID: <87a7t5urg0.fsf@kamboji.qca.qualcomm.com> (sfid-20180512_115744_031435_D5F42579)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sriram R <srirrama@codeaurora.org> writes:

> In the 10.4-3.6 firmware branch there's a new DFS Host confirmation
> feature which is advertised using WMI_SERVICE_HOST_DFS_CHECK_SUPPORT flag.
>
> This new features enables the ath10k host to send information to the
> firmware on the specifications of detected radar type. This allows the
> firmware to validate if the host's radar pattern detector unit is
> operational and check if the radar information shared by host matches
> the radar pulses sent as phy error events from firmware. If the check
> fails the firmware won't allow use of DFS channels on AP mode when using
> FCC regulatory region.
>
> Supported Chipsets : QCA9984/QCA9888/QCA4019
> Firmware Version : 10.4-3.6-00104
>
> Signed-off-by: Sriram R <srirrama@codeaurora.org>

This introduces a new checkpatch warning:

drivers/net/wireless/ath/ath10k/wmi.c:3753: Please use a blank line after function/struct/union/enum declarations

-- 
Kalle Valo

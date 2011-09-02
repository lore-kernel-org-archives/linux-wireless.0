Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:50471 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933047Ab1IBJbw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Sep 2011 05:31:52 -0400
Message-ID: <4E60A283.9080006@qca.qualcomm.com> (sfid-20110902_113156_250101_2E0C04EA)
Date: Fri, 2 Sep 2011 12:31:47 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vivek Natarajan <nataraja@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: Add debugfs entry to modify roaming parameters.
References: <1314783139-19254-1-git-send-email-nataraja@qca.qualcomm.com>
In-Reply-To: <1314783139-19254-1-git-send-email-nataraja@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/31/2011 12:32 PM, Vivek Natarajan wrote:
> Firmware initiates roaming only after it reaches a rssi of 20.
> This lower rssi threshold can be modified through a wmi command
> to modify the roaming behavior.

Thanks, applied with minor changes:

commit e5090444be811ce45653969363be8fcb4c52d597
Author: Vivek Natarajan <nataraja@qca.qualcomm.com>
Date:   Wed Aug 31 15:02:19 2011 +0530

    ath6kl: Add debugfs entry to modify roaming parameters.

    Firmware initiates roaming only after it reaches a rssi of 20.
    This lower rssi threshold can be modified through a wmi command
    to modify the roaming behavior.

    kvalo: rename debugfs functions and move comment about rssi units
next to
    ath6kl_wmi_set_roam_lrssi_cmd()

    Signed-off-by: Vivek Natarajan <nataraja@qca.qualcomm.com>
    Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Kalle

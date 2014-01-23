Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:58579 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482AbaAWMyj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jan 2014 07:54:39 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath10k: enable firmware STA quick kickout
References: <20140120090146.5500.12995.stgit@potku.adurom.net>
Date: Thu, 23 Jan 2014 14:54:33 +0200
In-Reply-To: <20140120090146.5500.12995.stgit@potku.adurom.net> (Kalle Valo's
	message of "Mon, 20 Jan 2014 11:01:46 +0200")
Message-ID: <87ob325052.fsf@kamboji.qca.qualcomm.com> (sfid-20140123_135443_660188_F21B18C4)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> Firmware has a feature to track if the associated STA is not acking the frames.
> When that happens, the firmware sends WMI_PEER_STA_KICKOUT_EVENTID event to the
> host. Enable that to faster detect when a STA has left BSS without sending a
> deauth frame.
>
> Also set huge keepalive timeouts to avoid using the keepalive functionality in
> the firmware.
>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Applied.

-- 
Kalle Valo

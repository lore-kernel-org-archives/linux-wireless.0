Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:26474 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303AbaATJIR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jan 2014 04:08:17 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath10k: enable firmware STA quick kickout
References: <20140120090146.5500.12995.stgit@potku.adurom.net>
Date: Mon, 20 Jan 2014 11:08:12 +0200
In-Reply-To: <20140120090146.5500.12995.stgit@potku.adurom.net> (Kalle Valo's
	message of "Mon, 20 Jan 2014 11:01:46 +0200")
Message-ID: <87sisjkolf.fsf@kamboji.qca.qualcomm.com> (sfid-20140120_100825_461699_CAC68DF6)
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

In this v2 I fixed the warning messages.

-- 
Kalle Valo

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:57659 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794AbbAZJKL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jan 2015 04:10:11 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 3/3] ath10k: add support for qca6174
References: <1421407237-24159-1-git-send-email-michal.kazior@tieto.com>
	<1421407237-24159-3-git-send-email-michal.kazior@tieto.com>
Date: Mon, 26 Jan 2015 11:10:00 +0200
In-Reply-To: <1421407237-24159-3-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Fri, 16 Jan 2015 12:20:37 +0100")
Message-ID: <87wq49gb6f.fsf@kamboji.qca.qualcomm.com> (sfid-20150126_101032_739002_BE7A30DE)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> The QCA6174 in combination with new wmi-tlv
> firmware is capable of multi-channel, beamforming,
> tdls and other features.
>
> This patch just makes it possible to boot these
> devices and do some basic stuff. Some things may
> not work or may be unreliable. New features will
> be implemented later. This will be addressed
> eventually with future patches.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

[...]

> +++ b/drivers/net/wireless/ath/ath10k/hw.c
> @@ -0,0 +1,59 @@
> +/*
> + * Copyright (c) 2005-2011 Atheros Communications Inc.
> + * Copyright (c) 2011-2014 Qualcomm Atheros, Inc.

I think this needs to be:

Copyright (c) 2014-2015 Qualcomm Atheros, Inc.

I can change that.

-- 
Kalle Valo

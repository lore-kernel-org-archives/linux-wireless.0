Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:58548 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758241AbbA0OCw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2015 09:02:52 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/3] ath10k: reset chip before reading chip_id in probe
References: <1421407237-24159-1-git-send-email-michal.kazior@tieto.com>
Date: Tue, 27 Jan 2015 16:02:19 +0200
In-Reply-To: <1421407237-24159-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Fri, 16 Jan 2015 12:20:35 +0100")
Message-ID: <87386wcoes.fsf@kamboji.qca.qualcomm.com> (sfid-20150127_150304_546564_A381A2A1)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> There are some very rare cases with some hardware
> configuration that the device doesn't init quickly
> enough in which case reading chip_id yielded 0.
> This caused driver to subsequently fail to setup
> the device.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, all three patches applied to ath.git.

-- 
Kalle Valo

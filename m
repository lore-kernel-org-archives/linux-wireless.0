Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:25463 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932185AbcEXRxF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 May 2016 13:53:05 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: ath10k: improve tx scheduling
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1462796708-13880-1-git-send-email-michal.kazior@tieto.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
	"Michal Kazior" <michal.kazior@tieto.com>
Message-ID: <58d94fea017e4e04aa287f9cc45d7a6c@euamsexm01a.eu.qualcomm.com> (sfid-20160524_195311_481940_CFB4FD3D)
Date: Tue, 24 May 2016 19:52:55 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> wrote:
> Recent changes revolving around implementing
> wake_tx_queue support introduced a significant
> performance regressions on some (slower, uni-proc)
> systems.
> 
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, 1 patch applied to ath.git:

7a0adc83f34d ath10k: improve tx scheduling

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9045961/


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:2873 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029AbcFNL7d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jun 2016 07:59:33 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/2] ath10k: Define an enum to enable cycle counter wraparound
 logic
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1464968596-19834-1-git-send-email-vthiagar@qti.qualcomm.com>
To: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>,
	Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>,
	<linux-wireless@vger.kernel.org>
Message-ID: <751c58687e0842228c179608fd4018ce@euamsexm01a.eu.qualcomm.com> (sfid-20160614_135937_639637_5B4A3547)
Date: Tue, 14 Jun 2016 13:59:27 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com> wrote:
> QCA988X hw implements a different cycle counter wraparound
> behaviour when compared to QCA4019. To properly handle different
> wraparound logic for these chipsets replace already available
> bool hw_params member, has_shifted_cc_wraparound, with an
> enum which could be extended to handle different wraparound
> behaviour. This patch keeps the existing logic functionally
> same and a prepares cycle counter wraparound handling to
> extend for other chips.
> 
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>

Thanks, 2 patches applied to ath-next branch of ath.git:

26c197600b43 ath10k: define an enum to enable cycle counter wraparound logic
8e100354a985 ath10k: fix cycle counter wraparound handling for QCA4019

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9153403/


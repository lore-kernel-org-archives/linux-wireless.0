Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:29996 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbbJ1TfW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 15:35:22 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <c_mkenna@qti.qualcomm.com>
CC: Manikanta Pubbisetty <c_mpubbi@qti.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCHv3] ath10k: Enable adaptive CCA
References: <1444817777-12195-1-git-send-email-c_mkenna@qti.qualcomm.com>
Date: Wed, 28 Oct 2015 21:35:00 +0200
In-Reply-To: <1444817777-12195-1-git-send-email-c_mkenna@qti.qualcomm.com> (c.
	mkenna's message of "Wed, 14 Oct 2015 15:46:17 +0530")
Message-ID: <87vb9qss63.fsf@kamboji.qca.qualcomm.com> (sfid-20151028_203530_014166_A202F980)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

<c_mkenna@qti.qualcomm.com> writes:

> From: Maharaja <c_mkenna@qti.qualcomm.com>
>
> European Union has made it mandatory that all devices working in 2.4 GHz
> has to adhere to the ETSI specification (ETSI EN 300 328 V1.9.1)
> beginnig this year. The standard basically speaks about interferences
> in 2.4Ghz band.
> For example, when 802.11 device detects interference, TX must be stopped
> as long as interference is present.
>
> Adaptive CCA is a feature, when enabled the device learns from the
> environment and configures CCA levels adaptively. This will improve
> detecting interferences and the device can stop trasmissions till the
> interference is present eventually leading to good performances in
> varying interference conditions.
>
> The patch includes code for enabling adaptive CCA for 10.2.4 firmware on
> QCA988X.
>
> Signed-off-by: Maharaja <c_mkenna@qti.qualcomm.com>
> Signed-off-by: Manikanta Pubbisetty <c_mpubbi@qti.qualcomm.com>

Applied, thanks.

-- 
Kalle Valo

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:46150 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932068AbbBOPDQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Feb 2015 10:03:16 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <greearb@candelatech.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH 1/8] ath10k: scan should handle scan-start-failed event properly.
References: <1421087564-10384-1-git-send-email-greearb@candelatech.com>
	<878ugeul6u.fsf@kamboji.qca.qualcomm.com>
Date: Sun, 15 Feb 2015 17:03:10 +0200
In-Reply-To: <878ugeul6u.fsf@kamboji.qca.qualcomm.com> (Kalle Valo's message
	of "Wed, 4 Feb 2015 10:37:13 +0200")
Message-ID: <874mqni5e9.fsf@kamboji.qca.qualcomm.com> (sfid-20150215_160321_162262_C5BACA62)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> These patches are now in the pending branch.
>
> 86f50c71b224 ath10k: scan should handle scan-start-failed event properly
> c6dde373a4bb ath10k: fix spelling mistakes and add details to mac logging
> 198c0184d94c ath10k: fix spelling in htt code comment
> 227822d52d26 ath10k: fix CE_DESC_FLAGS_META_DATA_LSB definition

Thanks, applied to ath.git.

-- 
Kalle Valo

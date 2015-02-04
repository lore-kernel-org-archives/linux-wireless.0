Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:21149 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932408AbbBDIhc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2015 03:37:32 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <greearb@candelatech.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/8] ath10k: scan should handle scan-start-failed event properly.
References: <1421087564-10384-1-git-send-email-greearb@candelatech.com>
Date: Wed, 4 Feb 2015 10:37:13 +0200
In-Reply-To: <1421087564-10384-1-git-send-email-greearb@candelatech.com>
	(greearb@candelatech.com's message of "Mon, 12 Jan 2015 10:32:37
	-0800")
Message-ID: <878ugeul6u.fsf@kamboji.qca.qualcomm.com> (sfid-20150204_093735_673997_3C971590)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

greearb@candelatech.com writes:

> From: Ben Greear <greearb@candelatech.com>
>
> In case firmware fails to start the scan, then complete
> the start condition and clean up so that driver does not
> block on timeout.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>

These patches are now in the pending branch.

86f50c71b224 ath10k: scan should handle scan-start-failed event properly
c6dde373a4bb ath10k: fix spelling mistakes and add details to mac logging
198c0184d94c ath10k: fix spelling in htt code comment
227822d52d26 ath10k: fix CE_DESC_FLAGS_META_DATA_LSB definition

I dropped the rest as I really would like to avoid maintaining yet
another firmware branch.

-- 
Kalle Valo

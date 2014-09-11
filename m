Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:30254 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932149AbaIKUnT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2014 16:43:19 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v4 0/2] ath10k: testmode support
References: <20140910152136.12610.18499.stgit@potku.adurom.net>
Date: Thu, 11 Sep 2014 23:43:13 +0300
In-Reply-To: <20140910152136.12610.18499.stgit@potku.adurom.net> (Kalle Valo's
	message of "Wed, 10 Sep 2014 18:23:16 +0300")
Message-ID: <87zje528im.fsf@kamboji.qca.qualcomm.com> (sfid-20140911_224324_420010_01DF17A0)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> latest version of my testmode patches. Getting closer, more or less cosmetic
> changes this time :)
>

[...]

>
> Kalle Valo (2):
>       ath10k: make ath10k_wmi_cmd_send() public
>       ath10k: add testmode

Applied, with an addition of the small change in patch 2 suggested by
Michal.

-- 
Kalle Valo

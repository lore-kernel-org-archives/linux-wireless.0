Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:65389 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbbAIQNY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2015 11:13:24 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath10k: fix build error when hwmon is off
References: <20150107150410.17433.49263.stgit@potku.adurom.net>
Date: Fri, 9 Jan 2015 18:13:18 +0200
In-Reply-To: <20150107150410.17433.49263.stgit@potku.adurom.net> (Kalle Valo's
	message of "Wed, 7 Jan 2015 17:04:10 +0200")
Message-ID: <87ppaohqzl.fsf@kamboji.qca.qualcomm.com> (sfid-20150109_171328_045810_E258AD89)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> kbuild reported a linking error:
>
> ERROR: "devm_hwmon_device_register_with_groups"
> [drivers/net/wireless/ath/ath10k/ath10k_core.ko] undefined!
>
> Fix it by returning early and letting the compiler to optimise out the function
> call.
>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Applied to ath.git.

-- 
Kalle Valo

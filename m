Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17619 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406AbaLWRnQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2014 12:43:16 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Sebastian Gottschall <s.gottschall@dd-wrt.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 8/8] ath10k: add thermal sensor device support
References: <20141217101755.15964.2625.stgit@potku.adurom.net>
	<20141217102226.15964.32919.stgit@potku.adurom.net>
	<5491D20F.2020202@dd-wrt.com>
Date: Tue, 23 Dec 2014 19:43:06 +0200
In-Reply-To: <5491D20F.2020202@dd-wrt.com> (Sebastian Gottschall's message of
	"Wed, 17 Dec 2014 19:57:19 +0100")
Message-ID: <87tx0mcled.fsf@kamboji.qca.qualcomm.com> (sfid-20141223_184319_735561_589D4FD4)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sebastian Gottschall <s.gottschall@dd-wrt.com> writes:

> the whole code will not work. the firmware 10.2.4 returns op_version 3
> so this check here fails
>
> if (ar->wmi.op_version != ATH10K_FW_WMI_OP_VERSION_10_2_4)
>
> since 5 is required

I know, I used firmware-4.bin_10.2.4.13-2 to test this. I just didn't
have a chance to upload it until now:

https://github.com/kvalo/ath10k-firmware/tree/master/10.2.4

-- 
Kalle Valo

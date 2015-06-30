Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:31646 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbbF3MOJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jun 2015 08:14:09 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH V2 00/10] Add QCA99X0 support
References: <1434610870-5505-1-git-send-email-vthiagar@qti.qualcomm.com>
Date: Tue, 30 Jun 2015 15:13:56 +0300
In-Reply-To: <1434610870-5505-1-git-send-email-vthiagar@qti.qualcomm.com>
	(Vasanthakumar Thiagarajan's message of "Thu, 18 Jun 2015 12:31:00
	+0530")
Message-ID: <8761652y2j.fsf@kamboji.qca.qualcomm.com> (sfid-20150630_141416_785329_1C0232B3)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com> writes:

> This patch set adds changes for QCA99X0 chip in pci probe,
> Copy Engine init and firmware downloads. Since it is still
> work in progress the support for this chip is not yet
> advertised in pci device table.
>
> Vasanthakumar Thiagarajan (10):
>   ath10k: Add a table to store hw specific values
>   ath10k: Add new reg_address/mask to hw register table
>   ath10k: Add hw register/values for QCA99X0 chip
>   ath10k: Copy Engine related changes for QCA99X0
>   ath10k: Make target cpu address to CE address conversion chip specific
>   ath10k: Add chip reset sequence for QCA99X0
>   ath10k: Extend CE src desc flags for interrupt indication
>   ath10k: Fix BMI communication timeout for QCA99X0
>   ath10k: Add support for code swap
>   ath10k: Add BMI param value to execute otp to hw_param

Thanks, applied.

-- 
Kalle Valo

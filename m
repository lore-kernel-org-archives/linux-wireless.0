Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:34697 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810AbcF3Lge convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2016 07:36:34 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "Raja, Tamizh Chelvam" <c_traja@qti.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCHV2 3/3] ath10k: add testmode support for 10.4 firmware
Date: Thu, 30 Jun 2016 11:36:26 +0000
Message-ID: <87eg7e6h8n.fsf@kamboji.qca.qualcomm.com> (sfid-20160630_133637_975748_B671FF20)
References: <1467018454-24530-1-git-send-email-c_traja@qti.qualcomm.com>
In-Reply-To: <1467018454-24530-1-git-send-email-c_traja@qti.qualcomm.com> (c.
	traja's message of "Mon, 27 Jun 2016 14:37:34 +0530")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

<c_traja@qti.qualcomm.com> writes:

> From: Tamizh chelvam <c_traja@qti.qualcomm.com>
>
> This patch adds testmode support for QCA99X0 chipsets which uses
> 10.4 firmware and added code swap support for UTF binary.
>
> Signed-off-by: Tamizh chelvam <c_traja@qti.qualcomm.com>

There were few checkpatch warnings, I fixed them in the pending branch:

$ ath10k-check 
drivers/net/wireless/ath/ath10k/testmode.c:247: Alignment should match open parenthesis
drivers/net/wireless/ath/ath10k/testmode.c:250: Alignment should match open parenthesis
drivers/net/wireless/ath/ath10k/testmode.c:298: Alignment should match open parenthesis
drivers/net/wireless/ath/ath10k/testmode.c:325: Alignment should match open parenthesis

-- 
Kalle Valo
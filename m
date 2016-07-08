Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:40430 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049AbcGHHyI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2016 03:54:08 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "Raja, Tamizh Chelvam" <c_traja@qti.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"tamizhchelvam@codeaurora.org" <tamizhchelvam@codeaurora.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCHv3 3/3] ath10k: add testmode support for 10.4 firmware
Date: Fri, 8 Jul 2016 07:54:00 +0000
Message-ID: <87r3b41s6f.fsf@kamboji.qca.qualcomm.com> (sfid-20160708_095413_690398_6505B2FD)
References: <1467356835-31836-1-git-send-email-c_traja@qti.qualcomm.com>
In-Reply-To: <1467356835-31836-1-git-send-email-c_traja@qti.qualcomm.com> (c.
	traja's message of "Fri, 1 Jul 2016 12:37:15 +0530")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

<c_traja@qti.qualcomm.com> writes:

> From: Tamizh chelvam <c_traja@qti.qualcomm.com>
>
> This patch adds testmode support for 10.4 based chipsets
> and added code swap support for UTF binary.
>
> Signed-off-by: Tamizh chelvam <c_traja@qti.qualcomm.com>

This patch introduced new checkpatch warnings:

drivers/net/wireless/ath/ath10k/testmode.c:247: Alignment should match open parenthesis
drivers/net/wireless/ath/ath10k/testmode.c:250: Alignment should match open parenthesis

I fixed these in the pending branch.

-- 
Kalle Valo
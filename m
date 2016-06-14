Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:46186 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961AbcFNLyB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jun 2016 07:54:01 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "Thiagarajan, Vasanthakumar" <vthiagar@qti.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: Fix some of the macro definitions of HTT_RX_IND
 message
Date: Tue, 14 Jun 2016 11:53:53 +0000
Message-ID: <87wpls2dgv.fsf@kamboji.qca.qualcomm.com> (sfid-20160614_135417_471973_E687712C)
References: <1464870025-4557-1-git-send-email-vthiagar@qti.qualcomm.com>
In-Reply-To: <1464870025-4557-1-git-send-email-vthiagar@qti.qualcomm.com>
	(Vasanthakumar Thiagarajan's message of "Thu, 2 Jun 2016 17:50:25	+0530")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com> writes:

> Only five bits are defined to pass tid information in HTT_RX_IND
> message, so the mask which can be used to extract tid should be 0x1f
> instead of the current 0x3f. Also, macros which can be used to extract
> flush_valid and release_valid bits have to be left shifted one bit less
> because these information follow the tid right after. This patch does
> not really fix anything functionally because these macros are not used
> currently.
>
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>

Applied to ath.git, thanks.

-- 
Kalle Valo
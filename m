Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43720 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810AbbCTNzx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2015 09:55:53 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Sujith Manoharan <sujith@msujith.org>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: Re: [PATCH v2 02/11] ath9k: Register private AIC ops
References: <1426312677-2064-1-git-send-email-sujith@msujith.org>
	<1426312677-2064-3-git-send-email-sujith@msujith.org>
	<87zj78gc7e.fsf@kamboji.qca.qualcomm.com>
	<21772.9425.486840.165998@gargle.gargle.HOWL>
Date: Fri, 20 Mar 2015 15:55:42 +0200
In-Reply-To: <21772.9425.486840.165998@gargle.gargle.HOWL> (Sujith Manoharan's
	message of "Fri, 20 Mar 2015 19:16:57 +0530")
Message-ID: <87wq2bg4dd.fsf@kamboji.qca.qualcomm.com> (sfid-20150320_145600_216129_FA249029)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith Manoharan <sujith@msujith.org> writes:

> Kalle Valo wrote:
>> I guess you already saw the error from kbuild:
>> 
>> >> ERROR: "ar9003_hw_attach_aic_ops" [drivers/net/wireless/ath/ath9k/ath9k_hw.ko] undefined!
>> 
>> Can you send a fix for this, please?
>
> This slipped through the radar...
> I've posted a patch: https://patchwork.kernel.org/patch/6056731/

Thanks, I'll apply it soon.

-- 
Kalle Valo

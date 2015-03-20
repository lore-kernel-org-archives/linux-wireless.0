Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:45486 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbbCTNnI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2015 09:43:08 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21772.9425.486840.165998@gargle.gargle.HOWL> (sfid-20150320_144312_782488_80D9DE3F)
Date: Fri, 20 Mar 2015 19:16:57 +0530
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: Re: [PATCH v2 02/11] ath9k: Register private AIC ops
In-Reply-To: <87zj78gc7e.fsf@kamboji.qca.qualcomm.com>
References: <1426312677-2064-1-git-send-email-sujith@msujith.org>
	<1426312677-2064-3-git-send-email-sujith@msujith.org>
	<87zj78gc7e.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo wrote:
> I guess you already saw the error from kbuild:
> 
> >> ERROR: "ar9003_hw_attach_aic_ops" [drivers/net/wireless/ath/ath9k/ath9k_hw.ko] undefined!
> 
> Can you send a fix for this, please?

This slipped through the radar...
I've posted a patch: https://patchwork.kernel.org/patch/6056731/

Sujith

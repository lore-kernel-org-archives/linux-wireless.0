Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:64000 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755541Ab1KUQGK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Nov 2011 11:06:10 -0500
Message-ID: <4ECA76EC.4000004@qca.qualcomm.com> (sfid-20111121_170616_786327_8459A56E)
Date: Mon, 21 Nov 2011 18:06:04 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/3] ath6kl: Remove modparam multi_norm_if_support
References: <1321590928-11646-1-git-send-email-vthiagar@qca.qualcomm.com>
In-Reply-To: <1321590928-11646-1-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/18/2011 06:35 AM, Vasanthakumar Thiagarajan wrote:
> This modparam was introduced to enable non-p2p mode operation
> on two virtual interfaces. It does not seem to be necessary to
> have a separate module parameter to do that. Instead, this option
> can be enabled when any one of the interfaces is not going to be
> used for p2p (ath6kl_p2p).
> 
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>

Thanks, all three patches applied.

Kalle

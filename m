Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:11140 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775Ab2H0OOY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Aug 2012 10:14:24 -0400
Message-ID: <503B80BB.70800@qca.qualcomm.com> (sfid-20120827_161427_471695_FECD78CC)
Date: Mon, 27 Aug 2012 17:14:19 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: consolidate WoW pattern length
References: <1345498010-21170-1-git-send-email-c_tpeder@qca.qualcomm.com>
In-Reply-To: <1345498010-21170-1-git-send-email-c_tpeder@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/21/2012 12:26 AM, Thomas Pedersen wrote:
> Since WOW_MASK_SIZE and WOW_PATTERN_SIZE have the same value, are
> logically equivalent, and part of the WMI API so therefore unlikely to
> change, consolidate these into WOW_PATTERN_SIZE.
> 
> Reported-by Kalle Valo <kvalo@qualcomm.com>
> Signed-off-by: Thomas Pedersen <c_tpeder@qca.qualcomm.com>

Thanks, applied.

I added the missing colon to the Reported-by line.

Kalle

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:62340 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753319AbdLGOVg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Dec 2017 09:21:36 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath6kl: remove redundant variable ies_len
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20171126053818.GA6602@blackstone>
References: <20171126053818.GA6602@blackstone>
To: Kenneth Lu <kuohsianglu@gmail.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl@lists.infradead.org>
Message-ID: <32f7ac8db56840b08cb75f504e28d509@euamsexm01a.eu.qualcomm.com> (sfid-20171207_152217_690907_A2FDB46F)
Date: Thu, 7 Dec 2017 15:21:28 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kenneth Lu <kuohsianglu@gmail.com> wrote:

> To get rid of W=1 warning: variable ‘ies_len’ set but not used.
> Variable ies_len is being assigned but never read.
> 
> Signed-off-by: Kenneth Lu <kuohsianglu@gmail.com>
> Reviewed-by: Steve deRosier <derosier@gmail.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

d786ebb2f59b ath6kl: remove redundant variable ies_len

-- 
https://patchwork.kernel.org/patch/10075235/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

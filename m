Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:33896 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752022AbdHCLa0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Aug 2017 07:30:26 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: set a-mpdu reference number in ath10k (receiver)
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <B8D63297-0A88-42A3-B789-3849895CF201@frei.media>
References: <B8D63297-0A88-42A3-B789-3849895CF201@frei.media>
To: Matthias Frei <mf@frei.media>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Message-ID: <be71938f7b3742c685e91c54cce1a7de@euamsexm01a.eu.qualcomm.com> (sfid-20170803_133031_625522_B89D55B2)
Date: Thu, 3 Aug 2017 13:30:19 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Matthias Frei <mf@frei.media> wrote:

> Set the a-mpdu reference number in ath10k to make it accessible in the
> receivers radiotap header. Implemented as in ath9k.  The reference number is
> needed for troubleshooting and research at the receivers site (e.g. to identify
> mpdu's that were aggregated in an a-mpdu)
> 
> Signed-off-by: Matthias Frei <mf@frei.media>
> [kvalo@qca.qualcomm.com: fix checkpatch warning, commit log cleanup]
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

47cc0ca91c9e ath10k: set a-mpdu receiver reference number

-- 
https://patchwork.kernel.org/patch/9826931/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

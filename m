Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:53039 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112AbbIIJpy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Sep 2015 05:45:54 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <c_mpubbi@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: invalid mcs reported in rx descriptor
References: <1441176665-3365-1-git-send-email-c_mpubbi@qti.qualcomm.com>
Date: Wed, 9 Sep 2015 12:45:42 +0300
In-Reply-To: <1441176665-3365-1-git-send-email-c_mpubbi@qti.qualcomm.com> (c.
	mpubbi's message of "Wed, 2 Sep 2015 12:21:05 +0530")
Message-ID: <87pp1s7wop.fsf@kamboji.qca.qualcomm.com> (sfid-20150909_114557_633612_6B752040)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

<c_mpubbi@qti.qualcomm.com> writes:

> From: Manikanta Pubbisetty <c_mpubbi@qti.qualcomm.com>
>
> Sometimes hardware reports invalid mcs index in rx descriptor
> when operating in VHT80 mode and all packets with invalid mcs
> will be eventually dropped in mac80211. This issue is observerd during
> testing on QCA99X0 chipsets.
>
> This patch adds a warn message for dumping the rx desc info which helps
> in analysing the issue when invalid mcs is received.
>
> Signed-off-by: Manikanta Pubbisetty <c_mpubbi@qti.qualcomm.com>

Thanks, applied. I just changed the commit title a bit:

commit 6ccea107eba46fbc7de40e944bf17145c2809666
Author: Manikanta Pubbisetty <c_mpubbi@qti.qualcomm.com>
Date:   Wed Sep 2 17:05:27 2015 +0300

    ath10k: print invalid mcs reported in rx descriptor

-- 
Kalle Valo

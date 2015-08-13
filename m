Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:49407 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbbHMLUv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2015 07:20:51 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] ath10k: remove futile fragmentation threshold config
References: <1438593403-316-1-git-send-email-michal.kazior@tieto.com>
Date: Thu, 13 Aug 2015 14:20:38 +0300
In-Reply-To: <1438593403-316-1-git-send-email-michal.kazior@tieto.com> (Michal
	Kazior's message of "Mon, 3 Aug 2015 11:16:42 +0200")
Message-ID: <87egj7o2nt.fsf@kamboji.qca.qualcomm.com> (sfid-20150813_132054_214036_B61FD87C)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Commit 1010ba4c5d1c ("ath10k: unregister and
> remove frag_threshold callback") didn't remove all
> instances of (futile) fragmentation threshold
> configuration. No known firmware supports the
> parameter so don't even bother setting it.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, both patches applied.

-- 
Kalle Valo

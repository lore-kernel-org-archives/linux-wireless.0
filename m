Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:33136 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756223Ab3HLORU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Aug 2013 10:17:20 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath10k: setup peer UAPSD flag correctly
References: <1375870249-29316-1-git-send-email-janusz.dziedzic@tieto.com>
Date: Mon, 12 Aug 2013 17:17:14 +0300
In-Reply-To: <1375870249-29316-1-git-send-email-janusz.dziedzic@tieto.com>
	(Janusz Dziedzic's message of "Wed, 7 Aug 2013 12:10:49 +0200")
Message-ID: <87txivt2mt.fsf@kamboji.qca.qualcomm.com> (sfid-20130812_161723_164325_A33C7C52)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Janusz Dziedzic <janusz.dziedzic@tieto.com> writes:

> Setup UAPSD peer/peer rate flags correctly.
> WMI_RC_UAPSD_FLAG is a peer rate capabilities flag
> and should not be set as a peer flag.
> Found during code review, doesn't fix a known
> issues.
>
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>

Thanks, applied.

-- 
Kalle Valo

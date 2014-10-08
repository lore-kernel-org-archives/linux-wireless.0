Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:33126 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754805AbaJHKVx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Oct 2014 06:21:53 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: don't create bssid peer for ibss
References: <1412251000-25377-1-git-send-email-janusz.dziedzic@tieto.com>
Date: Wed, 8 Oct 2014 13:21:25 +0300
In-Reply-To: <1412251000-25377-1-git-send-email-janusz.dziedzic@tieto.com>
	(Janusz Dziedzic's message of "Thu, 2 Oct 2014 13:56:40 +0200")
Message-ID: <87wq8ag8uy.fsf@kamboji.qca.qualcomm.com> (sfid-20141008_122156_508664_D1AD9B5F)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Janusz Dziedzic <janusz.dziedzic@tieto.com> writes:

> It's not really necessary to create bssid peer for
> bssid. Self-address peer is sufficient.
>
> This prevents some firmware revisions from crashing.
>
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>

Thanks, applied.

-- 
Kalle Valo

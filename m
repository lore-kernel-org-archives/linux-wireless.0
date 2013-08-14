Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:5243 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932683Ab3HNPBI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Aug 2013 11:01:08 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 0/4] ath10k: cleanups
References: <1375949650-9699-1-git-send-email-michal.kazior@tieto.com>
	<1376373297-32369-1-git-send-email-michal.kazior@tieto.com>
Date: Wed, 14 Aug 2013 18:00:38 +0300
In-Reply-To: <1376373297-32369-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Tue, 13 Aug 2013 07:54:53 +0200")
Message-ID: <87eh9w48rt.fsf@kamboji.qca.qualcomm.com> (sfid-20130814_170112_273272_CF7CA08D)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Hi,
>
> This patchset contains a few non-functional clean
> ups.
>
> v2:
>  * fix line over 80 chars
>
>
> Michal Kazior (4):
>   ath10k: clean up monitor start code
>   ath10k: use sizeof(*var) in kmalloc
>   ath10k: clean up PCI completion states
>   ath10k: print errcode when CE ring setup fails

Thanks, all four applied.

-- 
Kalle Valo

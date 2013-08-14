Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:17741 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932715Ab3HNPCg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Aug 2013 11:02:36 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 0/4] ath10k: fixes
References: <1375949813-10969-1-git-send-email-michal.kazior@tieto.com>
	<1376373578-2180-1-git-send-email-michal.kazior@tieto.com>
Date: Wed, 14 Aug 2013 18:02:30 +0300
In-Reply-To: <1376373578-2180-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Tue, 13 Aug 2013 07:59:34 +0200")
Message-ID: <87a9kk48op.fsf@kamboji.qca.qualcomm.com> (sfid-20130814_170238_635167_2C1BFF0B)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Hi,
>
> This patchset contains some bugfixes and
> improvements.
>
> v2:
>  * fix indentation
>  * use a comment instead of a no-op if clause
>

Thanks, these three patches applied:

>   ath10k: fix HTT service setup
>   ath10k: implement 802.3 SNAP rx decap type A-MSDU handling
>   ath10k: plug possible memory leak in WMI

This patch dropped per your request:

>   ath10k: fix HTC endpoint worker starvation

-- 
Kalle Valo

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:27640 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756007Ab3JGQb7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Oct 2013 12:31:59 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 0/2] ath10k: wep & ampdu fix
References: <to=1380292567-2363-1-git-send-email-michal.kazior@tieto.com>
	<1380874630-14280-1-git-send-email-michal.kazior@tieto.com>
Date: Mon, 7 Oct 2013 19:31:54 +0300
In-Reply-To: <1380874630-14280-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Fri, 4 Oct 2013 10:17:08 +0200")
Message-ID: <87txgtt539.fsf@kamboji.qca.qualcomm.com> (sfid-20131007_183214_172600_182AD157)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Hi,
>
> One throughput fix and one bug fix.
>
> The bug fix addresses my oversight when reworking
> HTC/WMI. I haven't seen the error yet but I'm
> quite certain this should be fixed.
>
> v2:
>  * A-MPDU patch contains a workaround for
>    Netgear/Linksys 11ac APs
>    (Kalle, can you kindly test this, please?)

I quickly tested patch 1 with D-Link DIR-865L. I didn't notice any
regressions so that part looks good. Though I didn't notice any
improvement either. But as long as there's no regression I'm happy :)

-- 
Kalle Valo

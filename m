Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:51884 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683AbbAOKdJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2015 05:33:09 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 0/5] ath10k: implement beacon offload
References: <1420715550-16017-1-git-send-email-michal.kazior@tieto.com>
Date: Thu, 15 Jan 2015 12:32:59 +0200
In-Reply-To: <1420715550-16017-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 8 Jan 2015 12:12:25 +0100")
Message-ID: <8761c8z63o.fsf@kamboji.qca.qualcomm.com> (sfid-20150115_113313_643071_A923C9DA)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Hi,
>
> New wmi-tlv firmware will support beacon/presp
> offloading. This patchset adds appropriate
> support.
>
> These patches of mine were originally posted by
> Bartosz before christmas after I went on my
> holidays.
>
> v2:
>  * add a comment in patch 5
>
>
> Michal Kazior (5):
>   ath10k: implement new beacon tx status event
>   ath10k: implement beacon template command
>   ath10k: implement prb tmpl wmi command
>   ath10k: implement p2p bcn ie command
>   ath10k: implement support for ap beacon offloading

Thanks, all five applied.

-- 
Kalle Valo

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:40067 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbaEPMek (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2014 08:34:40 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
	<apenwarr@gmail.com>
Subject: Re: [PATCH 0/3] ath10k: pci fixes 2014-05-15
References: <1400158139-13836-1-git-send-email-michal.kazior@tieto.com>
Date: Fri, 16 May 2014 15:34:34 +0300
In-Reply-To: <1400158139-13836-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 15 May 2014 14:48:56 +0200")
Message-ID: <878uq17vhh.fsf@kamboji.qca.qualcomm.com> (sfid-20140516_143443_006994_E6015F3F)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Hi,
>
> Patches 1 and 2 were made as a result of analysing
> `ath10k firmware crash after 4 hours of heavy TCP
> traffic` bug reported by Avery.
>
> Patch 3 fixes a bug reported by Avery that was
> apparently related to missing memory barriers on
> his ARM test system. @Avery, can you take a look
> or test it, please? I was never able to reproduce
> this but it just seems like the right thing to do.
> Or you can simply post your patch and I'll drop
> mine then.

I think it would be good still to wait a while with patch 3 as
apparently Avery is still seeing some odd firmware crashes. Once we are
confident that the memory barrier issues are handled we come up with a
final patch.

-- 
Kalle Valo

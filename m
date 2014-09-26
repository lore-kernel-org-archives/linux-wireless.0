Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:9565 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755172AbaIZKfF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2014 06:35:05 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 0/3] ath10k: debug improvements
References: <1411460574-5424-1-git-send-email-michal.kazior@tieto.com>
Date: Fri, 26 Sep 2014 13:34:58 +0300
In-Reply-To: <1411460574-5424-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Tue, 23 Sep 2014 10:22:51 +0200")
Message-ID: <87a95m6565.fsf@kamboji.qca.qualcomm.com> (sfid-20140926_123518_811547_2F9A3BB0)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Hi,
>
> This adds extra prints and information for
> debugging purposes.
>
>
> v2:
>  * merge scnprintfs
>
> Michal Kazior (3):
>   ath10k: print wmi version info
>   ath10k: dump hex bytes with dev string prefix
>   ath10k: add debug dump for pci rx

Thanks, all three applied.

-- 
Kalle Valo

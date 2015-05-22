Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:57870 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755849AbbEVKmM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 May 2015 06:42:12 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 0/3] ath10k: improve power efficiency
References: <1431076388-24800-1-git-send-email-michal.kazior@tieto.com>
	<1431941898-13591-1-git-send-email-michal.kazior@tieto.com>
Date: Fri, 22 May 2015 13:41:57 +0300
In-Reply-To: <1431941898-13591-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Mon, 18 May 2015 09:38:15 +0000")
Message-ID: <87bnhc6gi2.fsf@kamboji.qca.qualcomm.com> (sfid-20150522_124244_794383_7F248EDD)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Some measurements for QCA61X4:
>
>             Loaded    Started   Associated
> Unpatched    31mA      88mA       43mA
> Patched      14mA      15mA       23mA
>
> Loaded = module loaded, driver bound, no interface
>          is running
>
> Started = Loaded, but one client interface is
>           running, not associated
>
> Associated = Started, but associated to an AP as
>              client
>
> Note: Unpatched was consuming more power when
> Started than when Associated. This is no mistake.
>
> I didn't have a way to measure QCA988X.
>
>
> Janusz Dziedzic (2):
>   ath10k: enable ASPM
>   ath10k: fix idle power consumption
>
> Michal Kazior (1):
>   ath10k: enable pci soc powersaving

Thanks, all three applied.

-- 
Kalle Valo

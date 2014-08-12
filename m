Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:11987 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbaHLHtD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Aug 2014 03:49:03 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCHv2 0/2] ath10k: scan fixes 2014-07-21
References: <1407243284-19803-1-git-send-email-michal.kazior@tieto.com>
Date: Tue, 12 Aug 2014 10:48:57 +0300
In-Reply-To: <1407243284-19803-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Tue, 5 Aug 2014 14:54:42 +0200")
Message-ID: <87tx5iqhau.fsf@kamboji.qca.qualcomm.com> (sfid-20140812_094909_129342_B03F98C6)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> This addresses an issue found by Janusz with
> current spectral scan patches from Simon.
>
> This goes along patch `ath10k: prevent endless pci rx
> loop` I've posted a few days ago.
>
> There seems to be a condition in firmware which
> causes some WMI events to be not delivered by
> firmware to host most likely due to CE/PCI pipe
> being full (that's a guess judging by the huge
> amount of phyerrs reported and their behaviour
> while spectral scan is enabled). This also
> suggests some SWBA events may be dropped by
> firmware when spectral scan is running (same goes
> for management rx).
>
> v2:
>  * addressed some comments from Kalle
>  * fixed a few more issues
>
>
> Michal Kazior (2):
>   ath10k: simplify scan debug prints
>   ath10k: introduce a stricter scan state machine

Thanks, both patches applied.

-- 
Kalle Valo

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:2418 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753602AbbCLM5Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 08:57:25 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] ath10k: implement wmi roam event
References: <87fv9hyz2r.fsf@kamboji.qca.qualcomm.com>
	<1425908197-16118-1-git-send-email-michal.kazior@tieto.com>
Date: Thu, 12 Mar 2015 14:57:17 +0200
In-Reply-To: <1425908197-16118-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Mon, 9 Mar 2015 14:36:36 +0100")
Message-ID: <87pp8ev0eq.fsf@kamboji.qca.qualcomm.com> (sfid-20150312_135729_484137_CE1DC73C)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> This can be used to implement offloaded rssi
> threshold, beacon miss or even automatic
> in-firmware BSS roaming in the future.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, both patches applied.

-- 
Kalle Valo

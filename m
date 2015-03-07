Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:31005 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbbCGIqp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Mar 2015 03:46:45 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] ath10k: implement wmi roam event
References: <1425295932-10386-1-git-send-email-michal.kazior@tieto.com>
Date: Sat, 7 Mar 2015 10:46:36 +0200
In-Reply-To: <1425295932-10386-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Mon, 2 Mar 2015 12:32:11 +0100")
Message-ID: <87fv9hyz2r.fsf@kamboji.qca.qualcomm.com> (sfid-20150307_094649_474554_247BCC88)
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

These patches have non-trivial conflicts. Can you rebase, please?

-- 
Kalle Valo

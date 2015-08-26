Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:11731 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982AbbHZJK7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2015 05:10:59 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <arnd@arndb.de>,
	<linux-wireless@vger.kernel.org>, <twilightrook@gmail.com>,
	<oscarrydberg@gmail.com>, <vvanpo@gmail.com>,
	<joseph.salisbury@canonical.com>
Subject: Re: [PATCH/RFT 2/2] ath10k: rename qca6174 to qca61x4
References: <1439469147-9408-1-git-send-email-michal.kazior@tieto.com>
	<1439469147-9408-3-git-send-email-michal.kazior@tieto.com>
Date: Wed, 26 Aug 2015 12:10:51 +0300
In-Reply-To: <1439469147-9408-3-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 13 Aug 2015 14:32:27 +0200")
Message-ID: <87vbc21kkk.fsf@kamboji.qca.qualcomm.com> (sfid-20150826_111102_820686_C3CD4175)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> This cleans up the naming a little bit. Both
> QCA6174 and QCA6164 are in practice the same as
> far as driving them is concerned.
>
> Unfortunately firmware paths will need to stay
> untouched, i.e. QCA6164 firmware will still be
> looked for in QCA6174 to avoid breaking backward
> compatibility with older /lib/firmware setups.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Based on my previous comments I'll drop this.

-- 
Kalle Valo

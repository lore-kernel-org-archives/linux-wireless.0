Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:30764 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754448Ab3HBGfv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Aug 2013 02:35:51 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3] ath10k: implement get_survey()
References: <1375081712-9697-1-git-send-email-michal.kazior@tieto.com>
	<1375259560-8784-1-git-send-email-michal.kazior@tieto.com>
Date: Fri, 2 Aug 2013 09:35:41 +0300
In-Reply-To: <1375259560-8784-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Wed, 31 Jul 2013 10:32:40 +0200")
Message-ID: <87ob9gppky.fsf@kamboji.qca.qualcomm.com> (sfid-20130802_083605_935007_9E6A7E9D)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> This implements a limited subset of what can be
> reported in the survey dump.
>
> This can be used for assessing approximate channel
> load, e.g. for automatic channel selection.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo

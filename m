Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:57815 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbaLSNju (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Dec 2014 08:39:50 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Bartosz Markowski <bartosz.markowski@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: Re: [PATCH 1/5] ath10k: implement new beacon tx status event
References: <1418829711-19713-1-git-send-email-bartosz.markowski@tieto.com>
	<1418829711-19713-2-git-send-email-bartosz.markowski@tieto.com>
Date: Fri, 19 Dec 2014 15:39:34 +0200
In-Reply-To: <1418829711-19713-2-git-send-email-bartosz.markowski@tieto.com>
	(Bartosz Markowski's message of "Wed, 17 Dec 2014 16:21:47 +0100")
Message-ID: <87ppbfiwrt.fsf@kamboji.qca.qualcomm.com> (sfid-20141219_143953_577985_1B0DC822)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bartosz Markowski <bartosz.markowski@tieto.com> writes:

> From: Michal Kazior <michal.kazior@tieto.com>
>
> This event is delivered to host by firmware if it
> supports beacon templates only.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

If you submit something, even written by someone else, you have to add
your Signed-off-by line. Otherwise I cannot take these.

-- 
Kalle Valo

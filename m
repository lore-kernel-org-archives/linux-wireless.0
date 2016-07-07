Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:51092 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035AbcGGQcB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jul 2016 12:32:01 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "michal.kazior@tieto.com" <michal.kazior@tieto.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: disable wake_tx_queue for older devices
Date: Thu, 7 Jul 2016 16:30:48 +0000
Message-ID: <87zipt1kco.fsf@kamboji.qca.qualcomm.com> (sfid-20160707_183207_260436_07B8936D)
References: <1463489221-24989-1-git-send-email-michal.kazior@tieto.com>
	<1467201146-6844-1-git-send-email-michal.kazior@tieto.com>
In-Reply-To: <1467201146-6844-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Wed, 29 Jun 2016 13:52:26 +0200")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Ideally wake_tx_queue should be used regardless as
> it is a requirement for reducing bufferbloat and
> implementing airtime fairness in the future.
>
> However some setups (typically low-end platforms
> hosting QCA988X) suffer performance regressions
> with the current wake_tx_queue implementation.
> Therefore disable it unless it is really
> beneficial with current codebase (which is when
> firmware supports smart pull-push tx scheduling).
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

I think it's too late to send this to 4.7 anymore (and this due to my
vacation). So I'm planning to queue this to 4.8, but if the feedback is
positive we can always send this to a 4.7 stable release.

-- 
Kalle Valo
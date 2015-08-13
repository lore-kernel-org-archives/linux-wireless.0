Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:16511 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbbHMLWg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2015 07:22:36 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: initialize fw_features var
References: <1438750537-27781-1-git-send-email-michal.kazior@tieto.com>
Date: Thu, 13 Aug 2015 14:22:27 +0300
In-Reply-To: <1438750537-27781-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Wed, 5 Aug 2015 06:55:37 +0200")
Message-ID: <87614jo2ks.fsf@kamboji.qca.qualcomm.com> (sfid-20150813_132240_687250_0177CCF9)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> If firmware did not have any feature flags set the
> var would be left with values found on the stack
> (i.e. garbage) yielding print string like this:
>
>   (...) features \xffffffa6m:^R\xfffffffbԂ\xffffffc4^E
>
> Fixes: b27bc5a40f91 ("ath10k: dump fw features during probing")
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo

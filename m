Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:23803 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452AbcGSNTr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2016 09:19:47 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: disable wake_tx_queue for older devices
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1467201146-6844-1-git-send-email-michal.kazior@tieto.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>,
	<ath10k@lists.infradead.org>
Message-ID: <fddd6abaa3394cf5ae8133f627ffd47d@euamsexm01a.eu.qualcomm.com> (sfid-20160719_151951_006284_6B92BF4B)
Date: Tue, 19 Jul 2016 15:19:39 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> wrote:
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

Thanks, 1 patch applied to ath-next branch of ath.git:

4ca1807815aa ath10k: disable wake_tx_queue for older devices

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9204997/


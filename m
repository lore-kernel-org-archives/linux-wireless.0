Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:62987 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbaDHGjv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Apr 2014 02:39:51 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: cleanup debug messages in ath10k_wmi_event_host_swba()
References: <20140328093028.16927.81551.stgit@potku.adurom.net>
Date: Tue, 8 Apr 2014 09:39:46 +0300
In-Reply-To: <20140328093028.16927.81551.stgit@potku.adurom.net> (Kalle Valo's
	message of "Fri, 28 Mar 2014 11:30:28 +0200")
Message-ID: <8738honx3h.fsf@kamboji.qca.qualcomm.com> (sfid-20140408_083955_079452_8F44C654)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> They were just too superfluous and made it harder to read logs. Change them to
> follow the normal style used in ath10k.
>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Applied.

-- 
Kalle Valo

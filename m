Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:52176 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab3JIOPi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Oct 2013 10:15:38 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fix ath10k_debug_start() locking
References: <20131008184525.32604.64051.stgit@localhost6.localdomain6>
Date: Wed, 9 Oct 2013 17:15:32 +0300
In-Reply-To: <20131008184525.32604.64051.stgit@localhost6.localdomain6> (Kalle
	Valo's message of "Tue, 08 Oct 2013 21:45:25 +0300")
Message-ID: <87k3hmo7i3.fsf@kamboji.qca.qualcomm.com> (sfid-20131009_161541_968313_35BC6C6F)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> ath10k_debug_start() was not called with conf_mutex, fix that. Also there was a
> deadlock in ath10k_debug_stop(), rename it to ath10k_debug_destroy() and call
> it only when the device is destroyed.
>
> Reported-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Applied.

-- 
Kalle Valo

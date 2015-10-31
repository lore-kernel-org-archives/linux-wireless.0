Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:62640 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440AbbJaJhn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Oct 2015 05:37:43 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <c_traja@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: Add thermal throttling support for 10.4 firmware.
References: <1446108824-4675-1-git-send-email-c_traja@qti.qualcomm.com>
Date: Sat, 31 Oct 2015 11:37:23 +0200
In-Reply-To: <1446108824-4675-1-git-send-email-c_traja@qti.qualcomm.com> (c.
	traja's message of "Thu, 29 Oct 2015 14:23:44 +0530")
Message-ID: <87twp7idkc.fsf@kamboji.qca.qualcomm.com> (sfid-20151031_103747_478770_1006084E)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

<c_traja@qti.qualcomm.com> writes:

> From: Tamizh chelvam <c_traja@qti.qualcomm.com>
>
> This patch enables thermal throttling support for 10.4 firmware.
>
> Signed-off-by: Tamizh chelvam <c_traja@qti.qualcomm.com>

There was a trivial conflict, please check my conflict resolution in the
pending branch:

https://git.kernel.org/cgit/linux/kernel/git/kvalo/ath.git/commit/?h=pending&id=6a3b459d9bb84bf6ae02cef084895898b18316a4

-- 
Kalle Valo

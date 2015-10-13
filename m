Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:7405 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462AbbJMMu7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2015 08:50:59 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/2] ath10k: implement board API 2 support
In-Reply-To: <20151006131455.14278.28222.stgit@potku.adurom.net> (Kalle Valo's
	message of "Tue, 06 Oct 2015 16:15:39 +0300")
References: <20151006131455.14278.28222.stgit@potku.adurom.net>
Date: Tue, 13 Oct 2015 15:50:45 +0300
Message-ID: <87r3kzortm.fsf@kamboji.qca.qualcomm.com> (sfid-20151013_145103_869430_179606D5)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> Implement board 2 API to make it easier to have multiple board files and
> automatically choose correct one.
>
> ---
>
> Manikanta Pubbisetty (2):
>       ath10k: add board 2 API support
>       ath10k: select board data based on BMI chip id and board id

Applied.

-- 
Kalle Valo

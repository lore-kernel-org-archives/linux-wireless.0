Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:44982 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753602AbbCLNAm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 09:00:42 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/3] ath10k: fix wrong symlink name on error path
References: <1424437452-28161-1-git-send-email-rmanohar@qti.qualcomm.com>
	<1424437452-28161-2-git-send-email-rmanohar@qti.qualcomm.com>
Date: Thu, 12 Mar 2015 15:00:32 +0200
In-Reply-To: <1424437452-28161-2-git-send-email-rmanohar@qti.qualcomm.com>
	(Rajkumar Manoharan's message of "Fri, 20 Feb 2015 18:34:11 +0530")
Message-ID: <87h9tqv09b.fsf@kamboji.qca.qualcomm.com> (sfid-20150312_140050_939241_B4700CDA)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:

> Wrong symlink name is used on error path of thermal registration
> and also correcting the error message.
>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>

Thanks, patch 2 applied. Not sure yet what to do with patch 1 and 3.

-- 
Kalle Valo

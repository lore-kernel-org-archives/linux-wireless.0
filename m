Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:1457 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496AbbFIKvO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2015 06:51:14 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: prevent memory leak in wmi rx ops
References: <1433762607-28854-1-git-send-email-michal.kazior@tieto.com>
Date: Tue, 9 Jun 2015 13:51:08 +0300
In-Reply-To: <1433762607-28854-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Mon, 8 Jun 2015 13:23:27 +0200")
Message-ID: <87sia1f943.fsf@kamboji.qca.qualcomm.com> (sfid-20150609_125117_012638_E1315361)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Found during code review. This was pretty much
> impossible to happen but better safe than sorry.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:29857 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbbAMOYA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2015 09:24:00 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fix config_enabled check for hwmon
References: <1421139105-32025-1-git-send-email-rmanohar@qti.qualcomm.com>
Date: Tue, 13 Jan 2015 16:23:49 +0200
In-Reply-To: <1421139105-32025-1-git-send-email-rmanohar@qti.qualcomm.com>
	(Rajkumar Manoharan's message of "Tue, 13 Jan 2015 14:21:45 +0530")
Message-ID: <874mru69oq.fsf@kamboji.qca.qualcomm.com> (sfid-20150113_152409_943316_FEA93FF4)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:

> Because of wrong macro check in config_enabled, hwmon never be
> enabled. Fix that.
>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>

Ouch, thanks for fixing my bug. Applied to ath.git.

-- 
Kalle Valo

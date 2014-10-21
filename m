Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:62913 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaJUGy4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2014 02:54:56 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: add missing '\n' to warning and error messages
References: <20141006131708.3639.18609.stgit@potku.adurom.net>
Date: Tue, 21 Oct 2014 09:54:25 +0300
In-Reply-To: <20141006131708.3639.18609.stgit@potku.adurom.net> (Kalle Valo's
	message of "Mon, 06 Oct 2014 16:17:08 +0300")
Message-ID: <877fztzzdq.fsf@kamboji.qca.qualcomm.com> (sfid-20141021_085501_777906_DD2FF98F)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> All warning and error messages should end with '\n', fix that.
>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Joe pointed out that I had missed a few, will send v2.

-- 
Kalle Valo

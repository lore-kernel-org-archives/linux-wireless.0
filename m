Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:53858 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753774AbaKXOL3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:11:29 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: don't rebuild all the time
References: <1416423188-8394-1-git-send-email-johannes@sipsolutions.net>
Date: Mon, 24 Nov 2014 16:11:23 +0200
In-Reply-To: <1416423188-8394-1-git-send-email-johannes@sipsolutions.net>
	(Johannes Berg's message of "Wed, 19 Nov 2014 19:53:08 +0100")
Message-ID: <87wq6k6644.fsf@kamboji.qca.qualcomm.com> (sfid-20141124_151138_500760_6C68119D)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> There are better ways to get the kernel information, use the
> utsname and omit the version code entirely since it's duplicate.
> The version magic is rather useless anyway
>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

Thanks, applied.

-- 
Kalle Valo

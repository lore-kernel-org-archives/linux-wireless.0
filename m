Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:53135 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353AbcCWMJm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Mar 2016 08:09:42 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "michal.kazior@tieto.com" <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fix null deref if device crashes early
Date: Wed, 23 Mar 2016 12:09:37 +0000
Message-ID: <87d1qlfla6.fsf@kamboji.qca.qualcomm.com> (sfid-20160323_130945_297440_2C98E5C5)
References: <1458208328-16827-1-git-send-email-michal.kazior@tieto.com>
In-Reply-To: <1458208328-16827-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 17 Mar 2016 10:52:08 +0100")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> If device failed to init during early probing
> (which is quite rare) it triggered driver to
> compute crc before ar->firmware was ready causing
> an oops.
>
> Fixes: 3e58044b61a9 ("ath10k: print crc32 checksums for firmware and board files")
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Applied, thanks.

-- 
Kalle Valo
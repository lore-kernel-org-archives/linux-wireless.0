Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:9732 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112AbcCDIkU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2016 03:40:20 -0500
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "Shajakhan, Mohammed Shafi (Mohammed Shafi)"
	<mohammed@qti.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/2] Peer Stats fixes for rx duration
Date: Fri, 4 Mar 2016 08:40:14 +0000
Message-ID: <87egbqzleb.fsf@kamboji.qca.qualcomm.com> (sfid-20160304_094026_489558_F43CC8AE)
References: <1454513863-2703-1-git-send-email-mohammed@qca.qualcomm.com>
In-Reply-To: <1454513863-2703-1-git-send-email-mohammed@qca.qualcomm.com>
	(Mohammed Shafi Shajakhan's message of "Wed, 3 Feb 2016 21:07:41	+0530")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com> writes:

> From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
>
> This is a small patchset that fixes:
>
> 1. Updating rx duration per station (part of mac80211 STA debugfs)
> irrespective user does a cat fw_stats in ath10k debugfs
>
> 2. Remove updating peer stats list (which is completely useless)
> when we recieve periodic update of peer stats for updating rx_duration
>
> Mohammed Shafi Shajakhan (2):
>   ath10k: Fix updating peer stats rx duration
>   ath10k: Fix pointless update of peer stats list

Both applied, thanks.

-- 
Kalle Valo
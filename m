Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:24095 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590AbbHML3K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2015 07:29:10 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fix hw reconfig on wow failure
References: <1438769318-27373-1-git-send-email-michal.kazior@tieto.com>
Date: Thu, 13 Aug 2015 14:29:00 +0300
In-Reply-To: <1438769318-27373-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Wed, 5 Aug 2015 12:08:38 +0200")
Message-ID: <871tf7o29v.fsf@kamboji.qca.qualcomm.com> (sfid-20150813_132917_066452_E47CD4A7)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> When WoWLAN resume fails with retval 1 mac80211
> will attempt to reconfig the device in a similar
> manner when hw restart is requested. This wasn't
> handled properly and yielded call trace warnings
> and the device ended up not working.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo

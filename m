Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:13468 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054AbbHMLbd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2015 07:31:33 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] ath10k: don't remove peer that doesn't exist
References: <1438769724-29438-1-git-send-email-michal.kazior@tieto.com>
Date: Thu, 13 Aug 2015 14:31:20 +0300
In-Reply-To: <1438769724-29438-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Wed, 5 Aug 2015 12:15:23 +0200")
Message-ID: <87wpwzmnlj.fsf@kamboji.qca.qualcomm.com> (sfid-20150813_133138_131222_083F22EE)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> If peer creation failed during offchannel Tx the
> driver attempted to delete the peer nonetheless.
> This caused the ar->num_peers counter to be
> incorrectly decremented. This subsequently could
> cause the counter to drop below 0 and also
> eventually lead to firmware crash because host
> would think there are less peer entries created in
> firmware then there really were.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo
